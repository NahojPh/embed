#include <ArduinoBLE.h>

//The diff between the device deviceServiceUuid and the deviceServiceCharacteristicUuid is the 4 and 5 in the end.
const char* deviceServiceUuid = "19b10000-e8f2-537e-4f6c-d104768a1214"; 
const char* deviceServiceCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1215";


void setup() {
  //Having two values each for one side of the vehicle where the middle of the
  //255 value is where is changes the motor for that side so it can change direction.
  
  BLEService driveService(deviceServiceUuid); 
  //We only want to read and write without response because the client (phone) is the one who is going to control the speed.
  BLECharacteristic driveCharacteristic(deviceServiceCharacteristicUuid, BLERead | BLEWriteWithoutResponse, 7, false); 

  if (!BLE.begin()) {
    Serial.println("Could not start bt");
    while(1);
  }
  BLE.setLocalName("Bildriver");
  BLE.setAdvertisedService(driveService);
  Serial.println("Starting to advertise");
  driveService.addCharacteristic(driveCharacteristic);
  Serial.println("Added characteristic");
  BLE.addService(driveService);    
  Serial.println("Added the service");
  //driveCharacteristic.setValue("");
  Serial.println("Set inital data for the driveCharacteristic");
  driveCharacteristic.setValue("0:0");
  driveCharacteristic.setEventHandler(BLEWritten, driveValueWritten);

  BLE.advertise();

}

void loop() {
  //Polls for ble events :)
  BLE.poll();

}

void driveValueWritten(BLEDevice central, BLECharacteristic car) {
  
  char buf[7];
  car.readValue(buf, 7);
  /*
   * https://www.best-microcontroller-projects.com/arduino-strtok.html
  char str*;
  char *p = buf;

  while ((str = strtok(p, ":")) != "\n"){
    Serial.println(str);
    p = NULL;
  }
  */
  //String str = String(buf);
  //Serial.print(str);

  
  
}
