import 'package:flutter/material.dart';




class Home extends StatefulWidget {  
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
    
        child: Column(
          children: [
            Row( //Top row for the connection status bar and maybe the temp
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
              ],
            )
          ],
        ),
      ),
    );
  }
}