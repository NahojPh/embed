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

class _DevicePickerState extends State<DevicePicker> {
  
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
          await flutterBlue.connectedDevices.then((value) => value.forEach((element) {element.disconnect();}));
          if (widget.scanResult.advertisementData.connectable) {
            await widget.scanResult.device.connect()
            .onError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Could not connect to ${widget.scanResult.device.name}")
                )
              );
            }).then((value) async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Connected to ${widget.scanResult.device.name}")
                ),
              );
              
              var servs = await widget.scanResult.device.discoverServices();
              if (servs.first.characteristics.isNotEmpty) {
                Navigator.pushReplacementNamed(context, "/home", arguments: servs.first.characteristics.first); 
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