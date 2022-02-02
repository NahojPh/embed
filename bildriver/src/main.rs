#![allow(unused_imports)]


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

    //Creates a connection session with the bluetooth daemon.
    let session = bluer::Session::new().await?;

    //Finds the first adapter and initialize a interface with it then powering it on.
    let adapter_names = session.adapter_names().await?;
    let adapter_name = adapter_names.first().expect(format!("{} [Info] No Bluetooth adapter present", line!()));
    let adapter = session.adapter(adapter_name)?;
    adapter.set_powered(true).await?;

    println!("{} [Info] Advertising on Bluetooth adapter {} with address {}", line!(), &adapter_name, adapter.address().await?);
    let le_advertisement = Advertisement {
        service_uuids: vec![SERVICE_UUID].into_iter().collect(),
        discoverable: Some(true),
        local_name: Some("Bil driver".to_string()),
        ..Default::default()
    };
    //Creates an advertise object and starts advertise incase it finds a valid le_advertisement.
    let adv_handle = adapter.advertise(le_advertisement).await
        .expect(format!("{} [Error] Could not advertise the le_advertisement object.", line!()));
        
    

    println!("{} [Info] Serving Bil driver service on Bluetooth adapter {}",line!(), &adapter_name);
    let (char_control, char_handle) = characteristic_control();

    //Creates a write characteristic.
    let drive_char = Characteristic {
        uuid: CHARACTERISTIC_UUID,
        write: Some(CharacteristicWrite {
            write: true,
            write_without_response: true,
            method: CharacteristicWriteMethod::Io,

            ..Default::default()
        }),
        control_handle: char_handle,
        ..Default::default()
    };
/*    
    //Creates the steer characteristic with a write method.
    let steer_char = Characteristic {
        uuid: uuid::Uuid::from_u128(0xF00DC0DE00001),
        write: Some(CharacteristicWrite {
            write: true,
            write_without_response: true,
            method: CharacteristicWriteMethod::Io,
            ..Default::default()
        }),
        control_handle: char_handle,
        ..Default::default()
    };
 
*/ 

    //Creates the primary GATT Application to hold and handle the characteristics.
    let app = Application {
        services: vec![Service {
            uuid: SERVICE_UUID,
            primary: true,
            characteristics: vec![
                drive_char,
         ],
         ..Default::default()
        },?
        ],
            ..Default::default()
        };
    let app_handle = adapter.serve_gatt_application(app).await?;

    //Makes way to exit the application when enter is pressed.
    println!("{} [Info] Bil driver service is ready. Press enter to quit.", line!());
    let stdin = BufReader::new(tokio::io::stdin());
    let mut lines = stdin.lines();

    let mut read_buf: Vec<u8> = Vec::new();
    let mut reader_opt: Option<CharacteristicReader> = None;
    let mut writer_opt: Option<CharacteristicWriter> = None;
    
    pin_mut!(char_control);
    
    
    loop {
        tokio::select! {
            _ = lines.next_line() => break,
            evt = char_control.next() => {
                match evt {
                    Some(CharacteristicControlEvent::Write(req)) => {
                        println!("{} [Info] Accepting write request event with MTU {}", line!(), req.mtu());
                        //read_buf = vec![0; req.mtu()];
                        //reader_opt is an Option<CharacteristicReader> with impl to retrive characteristics data.
                        //Accepts the data to be written to the char and creates an Option<CharacteristicReader>.
                        reader_opt = Some(req.accept()?);
                        read_buf = reader_opt.unwrap().recv().await.unwrap();
                        
                        if read_buf.len() < 2 {
                            println!("{} [Warning] The incomming write request was smaler than 2", line!());
                            return;
                        }

                        read_buf[0]; //Left wheel
                        read_buf[1]; //Right wheel

                        

                        println!("{:?}", read_buf);
                        


                        
                    },
                    None => break,
                    _ => break,
                }
            },
            /*
            read_res = async {
                match &mut reader_opt {
                    Some(reader) if writer_opt.is_some() => reader.read(&mut read_buf).await,
                    _ => { 
                        println!("[Critical] For some reason the reader was suffed and the program is currently not pending forever.");
                        //future::pending().await
                    },
                }
            } => {
                //Here is where our written data is located to and where we are suspposed to use it.
                match read_res {
                    //This means that we got a empty write which terminates the CharacteristicReader
                    Ok(0) => {
                        println!("Read stream ended");
                        reader_opt = None;
                    }
                    //This is where we can use our data if its valid. Aka is more than 0 bytes.
                    Ok(n) => {
                        let value = read_buf[..n].to_vec();
                        println!("{:?}", value);
                        
                        if let Err(err) = writer_opt.as_mut().unwrap().write_all(&value).await {
                            println!("Write failed: {}", &err);
                            writer_opt = None;
                        }
                    }
                    //Incase error occurs.
                    Err(err) => {
                        println!("Read stream error: {}", &err);
                        reader_opt = None;
                    }
                }
            }
            */
        }
    }

    println!("Removing service and advertisement");
    drop(app_handle);
    drop(adv_handle);
    sleep(Duration::from_secs(1)).await;
    Ok(())
 }
