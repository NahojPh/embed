import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;



class Home extends StatefulWidget {  
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row( //Top row for the connection status bar and maybe the temp
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: const Icon(Icons.bluetooth),
                    onTap: () async {
                      if ( await flutterBlue.isAvailable && await flutterBlue.isOn) {
                        Navigator.pushNamed(context, "/scanner");
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Bluetooth doesnt seemm do be enabled, or it doesnt exisit on this device",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          )
                        );
                      }
                      
                    },
                    onLongPress: () {
                      Navigator.pushNamed(context, "/scanner");
                    },
                  ),
                  const SizedBox(width: 25),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}