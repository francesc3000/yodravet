import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomSnackBar {
  void show({@required BuildContext context, String message, IconData iconData}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        duration: Duration(seconds: 3),
        icon: Icon(iconData),
        backgroundColor: Colors.blue,
        backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent], ),
        message: message,
      )..show(context);
    });
  }
}
