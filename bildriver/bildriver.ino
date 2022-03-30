#include <ArduinoBLE.h>

const char* deviceServiceUuid = "19b10000-e8f2-537e-4f6c-d104768a1214";
const char* deviceServiceCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1214";


void setup() {
  char driveData[16] = "123456781234567";
  
  BLEService driveService(deviceServiceUuid); 
  BLECharacteristic driveCharacteristic(deviceServiceCharacteristicUuid, BLERead | BLEWriteWithoutResponse, driveData);

  if (!BLE.begin()) {
    serial.println("Could not start bt");
    while(1);
  }
  BLE.setLocalName("Bildriver");
  BLE.setAdvertisedService(driveService);
  gestureService.addCharacteristic(driveCharacteristic);
  BLE.addService(driveService);    
  gestureCharacteristic.writeValue("123456781234567");

  BLE.advertise();

}

void loop() {
  

}
