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
/*
use rppal::pwm::{
    Channel,
    Pwm, self,
};
*/

/// Service UUID for GATT example.
const SERVICE_UUID: uuid::Uuid = uuid::Uuid::from_u128(0xFEEDC0DE00002);

/// Characteristic UUID for GATT example.
const CHARACTERISTIC_UUID: uuid::Uuid = uuid::Uuid::from_u128(0xF00DC0DE00002);



#[tokio::main]
async fn main() {

    //Creates a connection session with the bluetooth daemon.
    let session = bluer::Session::new().await.expect("Bluer could not create a session which is bad.");

    //Finds the first adapter and initialize a interface with it then powering it on.
    let adapter_names = session.adapter_names().await.expect("Could not even find an adapter.");
    let adapter_name = adapter_names.first()
        .expect(format!("{} [Error] No Bluetooth adapter present", line!()).as_str());
    let adapter = session.adapter(adapter_name).expect("Could not create an interface with the adapter.");
    adapter.set_powered(true).await.expect("Could not give power to bt adapter.");

    println!("{} [Info] Advertising on Bluetooth adapter {} with address {}", line!(), &adapter_name, adapter.address().await
        .expect(format!("{} [Error] Could not fetch the adapter adress", line!()).as_str()));

    let le_advertisement = Advertisement {
        service_uuids: vec![SERVICE_UUID].into_iter().collect(),
        discoverable: Some(true),
        local_name: Some("Bil driver".to_string()),
        ..Default::default()
    };
    //Creates an advertise object and starts advertise incase it finds a valid le_advertisement.
    let adv_handle = adapter.advertise(le_advertisement).await
        .expect(format!("{} [Error] Could not advertise the le_advertisement object.", line!()).as_str());
        
    

    println!("{} [Info] Serving Bil driver service on Bluetooth adapter {}", line!(), &adapter_name);
    let (char_control, char_handle) = characteristic_control();


    //Change to with_frequency
    /*
    if Pwm::new(Channel::Pwm0).is_err() {
        println!("{} [Error] The creation of pwm0 retuned an error", line!());
        Ok(())
    }
    */
    
    //let pwm0 = Pwm::new(Channel::Pwm0).unwrap();
    //pwm0.enable();
    //println!("{}, [Info] Pwm0 is now enabled for use", line!());
    /*
    if Pwm::new(Channel::Pwm1).is_err() {
        println!("{} [Error] The creation of pwm1 retuned an error", line!());
        Ok(())
    }
    */
    //let pwm1 = Pwm::new(Channel::Pwm1).unwrap();

    //pwm1.enable();
    //println!("{}, [Info] Pwm1 is now enabled for use", line!());
    //TODO enable the pwm's before use.
    
    //Creates a write characteristic.
    let drive_char = Characteristic {
        uuid: CHARACTERISTIC_UUID,
        write: Some(CharacteristicWrite {
            write: true,
            write_without_response: true,
            method: CharacteristicWriteMethod::Io,
            ..Default::default()
        }),
        read: Some(CharacteristicRead {
            read: false,
            ..Default::default()
        }),
        control_handle: char_handle,
        ..Default::default()
    };


    //Creates the primary GATT Application to hold and handle the characteristics.
    let app = Application {
        services: vec![Service {
            uuid: SERVICE_UUID,
            primary: true,
            characteristics: vec![
                drive_char,
         ],
         ..Default::default()
        }
        ],
            ..Default::default()
        };
    let app_handle = adapter.serve_gatt_application(app).await.expect(format!("{} [Error] Could not serve the gatt application", line!()).as_str());

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
                        reader_opt = Some(req.accept().expect("Could not accept incomming bt request."));
                        read_buf = reader_opt.unwrap().recv().await.unwrap();
                        
                        if read_buf.len() < 2 {
                            println!("{} [Warning] The incomming write request was smaler than 2", line!());
                            return;
                        }

                        //read_buf[0]; //Left wheel
                        //read_buf[1]; //Right wheel
                        
                        //0 1 
                        /*
                        let pwm0_duty: f64 = ((read_buf[0] * 4) / 1024) as f64;
                        let pwm1_duty: f64 = ((read_buf[1] * 4) / 1024) as f64;

                        if pwm0.duty_cycle().unwrap_or(pwm0_duty) != pwm0_duty {
                            pwm0.set_duty_cycle(pwm0_duty);
                            println!("{} [Data] New pwm0 value: {}", line!(), pwm0_duty);
                        }
                        if pwm1.duty_cycle().unwrap_or(pwm1_duty) != pwm1_duty {
                            pwm1.set_duty_cycle(pwm1_duty);
                            println!("{} [Data] New pwm1 value: {}", line!(), pwm1_duty);
                        }
                        */
                        
                        
                        
                        

                        println!("{:?}", read_buf);
                        
                        ()

                        
                    },
                    None => break, // This might be a problem and should be changed to a continue.
                    _ => break,
                }
            },
      
        }
    }

    

    println!("Removing service and advertisement");
    drop(app_handle);
    drop(adv_handle);
    sleep(Duration::from_secs(1)).await;
 }

