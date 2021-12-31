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
              /*
              var servs = await widget.scanResult.device.discoverServices();
              var val = await servs.first.characteristics.first.read();
              print(utf8.decode(val));
              */
              Navigator.popAndPushNamed(context, "/home");
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