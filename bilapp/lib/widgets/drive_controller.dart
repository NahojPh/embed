import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:bilapp/models/bt_services.dart';
import 'package:bilapp/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DriveController extends StatefulWidget {
  final BluetoothCharacteristic charData;

  const DriveController(this.charData, { Key? key }) : super(key: key);

  @override
  _DriveControllerState createState() => _DriveControllerState();
}


class _DriveControllerState extends State<DriveController> {

  List<int> wheelControllerList = [0, 0];
  bool isIgnore = false;
  double rValue = 128;
  double lValue = 0;

  String value = "";






  @override
  Widget build(BuildContext context) {
    //sleep(const Duration(milliseconds: 500));
    

    return IgnorePointer(
      ignoring: isIgnore,
      child: SizedBox(
        child: Container(
          color: Colors.red,
          width: 800,
          height: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  value: lValue,
                  min: 0.0,
                  max: 255,
                  divisions: 8,
                  onChanged: (newValue) async {
                    wheelControllerList[0] = lValue.toInt();
                    await widget.charData.write(utf8.encode("${lValue.floor()}:${rValue.floor()}"));
                    setState(() => lValue = newValue);
                  }
                ),
              ),
              RotatedBox(
                quarterTurns: 0,
                child: Slider(
                  value: rValue,
                  min: 0.0,
                  max: 255,
                  divisions: 8,
                  onChanged: (newValue) async {
                    wheelControllerList[1] = rValue.toInt();
                    await widget.charData.write(utf8.encode("${lValue.floor()}:${rValue.floor()}"));
                    setState(() => rValue = newValue);
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> wait() async {  
}
