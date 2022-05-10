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
  
  char buf[8];
  car.readValue(buf, 7);
  buf[sizeof(buf)/sizeof(char)] = 0;


  // https://arduino.stackexchange.com/questions/1013/how-do-i-split-an-incoming-string
  // Read each command pair 
  char* command = strtok(buf, ":");
  while (command != 0)
  {
      // Split the command in two values
      char* separator = strchr(command, ':');
      if (separator != 0)
      {
          // Actually split the string in 2: replace ':' with 0
          *separator = 0;
          int driveSpeed = atoi(command);
          ++separator;
          int steerCont = atoi(separator);

          Serial.println(driveSpeed);
          Serial.println(steerCont);
        
      }
  }
  
  
  //Buffers for the L-lane and R-lane.
 // char lBuf[3];
//  char rBuf[3];
  
//  char divider = ':';
//  int bufSize = sizeof(buf)/sizeof(char);

//  strtok();

//  int driveSpeed = bufferToInt(lBuf);
//  int steerCont = bufferToInt(rBuf);
  //Docs: https://www.arduino.cc/reference/en/language/functions/analog-io/analogwrite/
  //If we have drager the (phone) slider to the left then one pwm gets activated.

  
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
