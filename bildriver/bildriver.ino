#include <ArduinoBLE.h>

BLEService carService("180F");


BLEIntCharacteristic carInfoChar("2A19", BLERead | BLENotify);
BLEIntCharacteristic carSteerChar("2A20", BLEWrite);
BLEShortCharacteristic carDriveChar("2A21", BLEWrite);



short OldDriveScale = 5; // 0 - 11 där 0 - 4 är bakåt, 5 är stilla och 6 - 11 är framåt.
int oldSteerScale = 15; // 0 - 14 är att svänga till vänster, 15 är att stå still och 16 - 31 är att svänga höger.

int oldCarInfo = 100000000;

void setup() {
  if (!BLE.begin()) {
    
  }

  BLE.setLocalName("Car-Captain");
  BLE.setAdvertisedService(carService); //Add the service uuid

  //Add characteristics
  carService.addCharacteristic(carInfoChar);
  carService.addCharacteristic(carSteerChar);
  carService.addCharacteristic(carDriveChar);

  //Add the car service
  BLE.addService(carService);

  //Set defaults for the characteristics. In this case the safests

  carInfoChar.writeValue(oldCarInfo);
  carDriveChar.writeValue(OldDriveScale);
  carSteerChar.writeValue(oldSteerScale);


  BLE.advertise();
}
bool con = false;
void loop() {

  //Poll for events
  BLE.poll();

  if (carDriveChar.written()) {
      if (carDriveChar.value() < 5) { // If controler makes a backwards move
        
       }
       else if (carDriveChar.value() > 5) { // If controler makes a stop
         
       }
       else { // If controler makes a forward move
           
       }
    } 
    
  
    

}
