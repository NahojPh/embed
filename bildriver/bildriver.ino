
#include <ArduinoBLE.h>

//The diff between the device deviceServiceUuid and the deviceServiceCharacteristicUuid is the 4 and 5 in the end.
const char* deviceServiceUuid = "19b10000-e8f2-537e-4f6c-d104768a1214"; 
const char* deviceServiceCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1215";


void setup() {
  //Having two values each for one side of the vehicle where the middle of the
  //255 value is where is changes the motor for that side so it can change direction.
  
  BLEService driveService(deviceServiceUuid); 
  //We only want to read and write without response because the client (phone) is the one who is going to control the speed.
  BLECharacteristic driveCharacteristic(deviceServiceCharacteristicUuid, BLERead | BLEWrite | BLEWriteWithoutResponse, 7, false); 

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
  
  char buf[8];
  car.readValue(buf, 7);



  // https://arduino.stackexchange.com/questions/1013/how-do-i-split-an-incoming-string


    // Split the command in two values
    char* separator = strchr(buf, ':');
    if (separator != 0)
    {
        // Actually split the string in 2: replace ':' with 0
        *separator = 0;
        int driveSpeed = atoi(buf);
        ++separator;
        int steerCont = atoi(separator);

        Serial.println(driveSpeed);
        Serial.println(steerCont);



        if (steerCont > 127) {
          //Analog write this incase its right
        }
        else {
          //Else analog write this if its left
        }
    }
  
}
