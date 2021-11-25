#include <ArduinoBLE.h>

BLEService carService("180F");


BLECharacteristic carInfoChar("2A19", BLERead, 12, sizeof(12));
BLECharCharacteristic carSteerChar("2A20", BLEWrite);
BLECharCharacteristic carDriveChar("2A21", BLEWrite);



short OldDriveScale = 0; // 0 - 11 där 0 - 4 är bakåt, 5 är stilla och 6 - 11 är framåt.
//char OldCarInfo[8] = ["0000000"];
char oldCarInfo[] = { '0', '0', '0', '0', '0', '0', '0', '0', '\0' };

void setup() {
  if (BLE.begin()) {
      
    }

  BLE.setLocalName("Car-Captain");
  BLE.setAdvertisedService(carService); //Add the service uuid

  //Add characteristics
  carService.addCharacteristic(carInfoChar);
  carService.addCharacteristic(carSteerChar);
  carService.addCharacteristic(carDriveChar);

}

void loop() {

}
