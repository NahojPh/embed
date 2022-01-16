import 'package:bilapp/widgets/bt_connect_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;


class Scanner extends StatefulWidget {
  const Scanner({ Key? key }) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  @override
  void initState() {
    flutterBlue.startScan(timeout: const Duration(seconds: 2));
    super.initState();
  }
  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration(seconds: 5)).then((value) => flutterBlue.startScan(timeout: const Duration(seconds: 2)));
    return Scaffold(
      body: Container(
       color: Theme.of(context).colorScheme.background,
    
       child: Column(
         children: [
           Center(
             child: Text(
               "BT Device list",
               style: TextStyle(
                 fontSize: 34,
                 color: Colors.grey[200]
               ),
             ),
           ),
           const SizedBox(height: 25),
           StreamBuilder<List<ScanResult>>(
             stream: flutterBlue.scanResults, 
             initialData: const [],
             
             builder: (context, snapshot) {
               List<Widget> devices = [];

                for (ScanResult r in snapshot.data!) {
                  devices += [DevicePicker(r)];
                }
                

               
              return Container(
                color: Colors.transparent,
                height: 300,
                width: 400,
                child: ListView(
                  children: devices,
                ),
              );
             }
           ),
         ],
       ),
        
      ),
    );
  }
}