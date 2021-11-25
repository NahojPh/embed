import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}