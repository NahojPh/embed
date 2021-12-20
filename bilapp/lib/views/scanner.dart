import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;


class Scanner extends StatefulWidget {
  const Scanner({ Key? key }) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}
  
    @override
    initState() {
      
      Future.delayed(Duration.zero).then((value) async {
        ;
        
                
      });
      
    }

class _ScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration(seconds: 5)).then((value) => flutterBlue.startScan(timeout: const Duration(seconds: 2)));
    flutterBlue.startScan(timeout: const Duration(seconds: 2));
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
           StreamBuilder<List<ScanResult>>(
             stream: flutterBlue.scanResults, 
             initialData: [],
             
             builder: (context, snapshot) {
               List<Widget> devices = [];

                for (ScanResult r in snapshot.data!) {
                  devices += [Text(r.rssi.toString())];
                }

               
              return Container(
                color: Colors.red,
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