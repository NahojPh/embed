# Embed
---
Embed is a project name with two smaler projects in it **BilDriver** and **BilApp**

## BilDriver
Bildriver is a arduino project which targets the Arduino nano 33 BLE and is receiving data from BilApp where the format of data is a string with two u8 values separated with a colon ":".


## BilApp
BilApp is a dart + flutter project with the flutter_blue library to send data to the Bildriver about the individual "wheel speed".



## To compile

### BilApp
Bilapp needs a working android phone with minSdkVersion set to 19.
At the moment BilApp only targets android phones.
**Note**
Because of unknown errors using a debug build is more stable than a release build.


### BilDriver
Bildriver just needs to target the Arduino nano 33 BLE using the arduino IDE and have the ArduinoBLE v1.2.2 library installed.
