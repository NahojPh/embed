import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:bilapp/models/bt_services.dart';
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
  double rValue = 0;
  double lValue = 0;


/*
  @override
  void initState() async {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        widget.charData.write(wheelControllerList);
        print("Just wrote to charData");
      });
      return true;
    });
    super.initState();
  }
*/
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
                  divisions: 4,
                  onChanged: (newValue) {
                    wheelControllerList[0] = lValue.toInt();
                    widget.charData.write(wheelControllerList, withoutResponse: false);  
                    setState(() => lValue = newValue);
                  }
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  value: rValue,
                  min: 0.0,
                  max: 255,
                  divisions: 4,
                  onChanged: (newValue) {
                    
                    wheelControllerList[1] = rValue.toInt();
                    widget.charData.write(wheelControllerList, withoutResponse: false);
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
