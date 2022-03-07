# Embed
---
Embed is a project name with two smaler projects in it **BilDriver** and **BilApp**

## BilDriver
Bildriver is a rust project with the libraries bluer and rppal. The driver has one ble peripheral service and one characteristic where "wheel data" is sent to.


## BilApp
BilApp is a dart + flutter project with the flutter_blue library to send data to the Bildriver about the "wheel speed".



## To compile

### BilApp
Bilapp needs a working android phone with minSdkVersion set to 19.


### BilDriver
BilDriver needs to be compiled on a rpi/linux device with the libbus-dev library and a working pkg-config executable.
