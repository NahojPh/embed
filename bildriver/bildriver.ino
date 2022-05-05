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
  
  //Buffers for the L-lane and R-lane.
  char lBuf[3];
  char rBuf[3];
  
  char divider = ':';
  int bufSize = sizeof(buf)/sizeof(char);
  
  for (int i = 0; i < bufSize; i++) {
    //To get the index of the divider.
    if (buf[i] == divider) {
      //To copy the data until it reached the size limit of lBuf.
      for (int a = 0; a < sizeof(lBuf)/sizeof(char); a++) {
        lBuf[a] = buf[a];
      }
      //a is initially set to i + 1 because we are setting the R-lane and 
      //the index is pointing at the divider and we need to go to the next one.
      for (int a = i+1; a < i; a++) {
        rBuf[a] = buf[a];
      }
      break;
    }
  }

  int driveSpeed = bufferToInt(lBuf);
  int steerCont = bufferToInt(rBuf);
  //Docs: https://www.arduino.cc/reference/en/language/functions/analog-io/analogwrite/
  //If we have drager the (phone) slider to the left then one pwm gets activated.
  if (steerCont < (254 / 2)) {
    
  }
  //Otherwise this pwm gets activated.
  else {
    
  }
  
  Serial.println(driveSpeed);
}


int bufferToInt(char* buff) {
    int sum = 0;
    //Use the index of the value with scientific notation to create an interger.
    int buffSize = sizeof(buff)/sizeof(char);

    for (int i = 0; i < buffSize; i++) {
        sum += (buff[i] * pow(10, buffSize - (i+1)));
    }
    return sum;
}
