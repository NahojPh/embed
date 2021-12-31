import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BtServiceNotifer with ChangeNotifier {
  final int service;

  BtServiceNotifer({required this.service});

  

  
}

var x = BtServiceNotifer(
  service: 12,
);


class BtServiceInfo extends InheritedWidget {
  final  service;
  
  const BtServiceInfo({Key? key, required this.service, child}):  super(key: key, child: child);
  
  static BtServiceInfo? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<BtServiceInfo>();
    assert(result != null, "No Bt service info was found, try connecting to a device");
    return result;
  } 

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
  
}