import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'dart:convert';

FlutterBlue flutterBlue = FlutterBlue.instance;

class DevicePicker extends StatefulWidget {
  final ScanResult scanResult;
  const DevicePicker(this.scanResult, {Key? key }) : super(key: key);

  @override
  State<DevicePicker> createState() => _DevicePickerState();
}

Future<void> disconnectDevices() async {
  await flutterBlue.connectedDevices.then((value) => value.forEach((element) {element.disconnect();}));
}

class _DevicePickerState extends State<DevicePicker> {


  @override
  void initState() {
    disconnectDevices();

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,

      child: ElevatedButton(

        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent)
        ),
        onPressed: () async {
          print("Presed");
          await flutterBlue.connectedDevices.then((value) => value.forEach((element) {element.disconnect();}));
          if (widget.scanResult.advertisementData.connectable) {
            print("Connectable");
            await widget.scanResult.device.connect()
            .onError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Could not connect to ${widget.scanResult.device.name}")
                )
              );
            }).then((value) async {
              print("here");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Connected to ${widget.scanResult.device.name}")
                ),
              );
              BluetoothCharacteristic? realBtChar;
              var servs = await widget.scanResult.device.discoverServices();
              if (servs.first.characteristics.isNotEmpty) {
                for (var s in servs) {
                  for (var char in s.characteristics) {
                    if (char.properties.write && char.properties.writeWithoutResponse) {
                      realBtChar = char;
                      break;
                    }
                    
                  }
                }
                if (realBtChar != null) {
                  print("Pushing you..");
                  Navigator.pushReplacementNamed(context, "/home", arguments: servs.last.characteristics.last); 
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Could not find a characteristic which fit the properties required.",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    )
                  );
                }
                
                //print("Char list: ${servs.first.characteristics}");


                /*
                print("Serv legnth: ${servs.length}");
                for (var item in servs) {
                  for (var i = 0; i < item.characteristics.length; i++) {
                    print("Write: ${item.characteristics[i].properties.write} Read: ${item.characteristics[i].properties.read} Length: ${item.characteristics.length}");
                  }
                  
                }
                */

              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "The amount of characteristics on the peripheral seems to be less than one.",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  )
                );
              }
            });
          }

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.scanResult.device.name, //Returns the device name
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            rssiInciationLight(widget.scanResult.rssi),
            //Text(scanResult.rssi.toString()),
          ],
        ),
        
      ),
    );
  }
}

Widget rssiInciationLight(int rssiValue) {

  if (rssiValue >= -39) {
    return const CircleAvatar(backgroundColor: Colors.green, maxRadius: 15.0);
  }
  else if (rssiValue <= -40 && rssiValue >= -79) {
    return const CircleAvatar(backgroundColor: Colors.orange, maxRadius: 15.0);
  }
  else {
    return const CircleAvatar(backgroundColor: Colors.red, maxRadius: 15.0);
  }

}