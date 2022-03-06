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
  double rControllerYOffset = 0.0;
  double lControllerYOffset = 0.0;

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


    return SizedBox(
      child: Container(
        color: Colors.red,
        width: 800,
        height: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                print(rControllerYOffset + details.delta.dy);
                setState(() {
                  rControllerYOffset = max(-85, rControllerYOffset + (details.delta.dy * 0.6));
                  rControllerYOffset = min(85, rControllerYOffset + (details.delta.dy * 0.6));
                });
                 wheelControllerList[1] = rControllerYOffset.toInt().abs();
              },
              onPanEnd: (details) => setState(() => 
                rControllerYOffset = 0.0
              ),
              child: Container(
                color: Colors.blue,
                height: 250,
                width: 80,
                child: Transform.translate(
                  offset: Offset(0.0, rControllerYOffset),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
            
                  )
                )
              ),
            ),
            GestureDetector(
              onPanUpdate: (details) {
                print(lControllerYOffset + details.delta.dy);
                setState(() {
                  lControllerYOffset = max(-85, lControllerYOffset + (details.delta.dy * 0.6));
                  lControllerYOffset = min(85, lControllerYOffset + (details.delta.dy * 0.6));
                });
                 wheelControllerList[0] = lControllerYOffset.toInt().abs();
              },
              onPanEnd: (details) => setState(() => 
                lControllerYOffset = 0.0
              ),
              child: Container(
                color: Colors.blue,
                height: 250,
                width: 80,
                child: Transform.translate(
                  offset: Offset(0.0, lControllerYOffset),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                  )
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}