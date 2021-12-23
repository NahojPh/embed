import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class DevicePicker extends StatefulWidget {
  final ScanResult scanResult;
  const DevicePicker(this.scanResult, {Key? key }) : super(key: key);

  @override
  State<DevicePicker> createState() => _DevicePickerState();
}

class _DevicePickerState extends State<DevicePicker> {
  String errorMessage = "";
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
              setState(() {
                errorMessage = error.toString();
              });
            }).then((value) {
              setState(() {
                errorMessage = "";
              });
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
            
            errorMessage != "" ? Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),

            ) : const SizedBox(),

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