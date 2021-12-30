//! Serves a Bluetooth GATT echo server.

use bluer::{
    adv::Advertisement,
    gatt::{
        local::{
            characteristic_control, Application, Characteristic, CharacteristicControlEvent,
            CharacteristicNotify, CharacteristicNotifyMethod, CharacteristicWrite, CharacteristicWriteMethod,
            Service, CharacteristicRead,
        },
        CharacteristicReader, CharacteristicWriter,
    },
};
use futures::{future, pin_mut, StreamExt};
use std::time::Duration;
use tokio::{
    io::{AsyncBufReadExt, AsyncReadExt, AsyncWriteExt, BufReader},
    time::sleep,
};
/// Service UUID for GATT example.
const SERVICE_UUID: uuid::Uuid = uuid::Uuid::from_u128(0xFEEDC0DE00002);

/// Characteristic UUID for GATT example.
const CHARACTERISTIC_UUID: uuid::Uuid = uuid::Uuid::from_u128(0xF00DC0DE00002);



#[tokio::main]
async fn main() -> bluer::Result<()> {

    let drive_char = Characteristic {
        uuid: uuid::Uuid::from_u128(0xF00DC0DE00002),
        write: Some(CharacteristicWrite {
            write: true,
            write_without_response: true,
            method: CharacteristicWriteMethod::Io,

            ..Default::default()
        }),
        control_handle: char_handle,
        ..Default::default()
    };
    //Creates a connection session with the bluetooth daemon.
    let session = bluer::Session::new().await?;

    //Finds the first adapter and initialize a interface with it then powering it on.
    let adapter_names = session.adapter_names().await?;
    let adapter_name = adapter_names.first().expect("No Bluetooth adapter present");
    let adapter = session.adapter(adapter_name)?;
    adapter.set_powered(true).await?;

    println!("Advertising on Bluetooth adapter {} with address {}", &adapter_name, adapter.address().await?);
    let le_advertisement = Advertisement {
        service_uuids: vec![SERVICE_UUID].into_iter().collect(),
        discoverable: Some(true),
        local_name: Some("Bil driver".to_string()),
        ..Default::default()
    };
    //Creates an advertise object and starts advertise incase it finds a valid le_advertisement.
    let adv_handle = adapter.advertise(le_advertisement).await
        .expect("Could not advertise the le_advertisement object.");
        
    

    println!("Serving Bil driver service on Bluetooth adapter {}", &adapter_name);
    let (char_control, char_handle) = characteristic_control();
    
    //Creates the primary GATT Application to hold and handle the characteristics.
    let app = Application {
        services: vec![Service {
            uuid: SERVICE_UUID,
            primary: true,
            characteristics: vec![
                drive_char,
            ],
            ..Default::default()
        }],
        ..Default::default()
    };
    let app_handle = adapter.serve_gatt_application(app).await?;

    //Makes way to exit the application when enter is pressed.
    println!("Bil driver service is ready. Press enter to quit.");
    let stdin = BufReader::new(tokio::io::stdin());
    let mut lines = stdin.lines();

    let mut read_buf = Vec::new();
    let mut reader_opt: Option<CharacteristicReader> = None;
    let mut writer_opt: Option<CharacteristicWriter> = None;
    pin_mut!(char_control);

    loop {
        tokio::select! {
            _ = lines.next_line() => break,
            evt = char_control.next() => {
                match evt {
                    Some(CharacteristicControlEvent::Write(req)) => {
                        println!("Accepting write request event with MTU {}", req.mtu());
                        read_buf = vec![0; req.mtu()];
                        //reader_opt is an Option<CharacteristicReader> with impl to retrive characteristics data.
                        reader_opt = Some(req.accept()?);
                        

                        
                    },
                    Some(CharacteristicControlEvent::Notify(notifier)) => {
                        println!("Accepting notify request event with MTU {}", notifier.mtu());
                        writer_opt = Some(notifier);
                    },
                    None => break,
                }
            },
            read_res = async {
                match &mut reader_opt {
                    Some(reader) if writer_opt.is_some() => reader.read(&mut read_buf).await,
                    _ => future::pending().await,
                }
            } => {
                match read_res {
                    Ok(0) => {
                        println!("Read stream ended");
                        reader_opt = None;
                    }
                    Ok(n) => {
                        let value = read_buf[..n].to_vec();
                        println!("Echoing {} bytes: {:x?} ... {:x?}", value.len(), &value[0..4.min(value.len())], &value[value.len().saturating_sub(4) ..]);
                        if value.len() < 512 {
                            println!();
                        }
                        if let Err(err) = writer_opt.as_mut().unwrap().write_all(&value).await {
                            println!("Write failed: {}", &err);
                            writer_opt = None;
                        }
                    }
                    Err(err) => {
                        println!("Read stream error: {}", &err);
                        reader_opt = None;
                    }
                }
            }
        }
    }

    println!("Removing service and advertisement");
    drop(app_handle);
    drop(adv_handle);
    sleep(Duration::from_secs(1)).await;

    Ok(())
}