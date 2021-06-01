import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flash/flash.dart';

class CustomSnackBar {
  void show(
      {@required BuildContext context, String message, IconData iconData}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Flushbar(
      //   duration: Duration(seconds: 3),
      //   icon: Icon(iconData),
      //   backgroundColor: Colors.blue,
      //   backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent], ),
      //   message: message,
      // )..show(context);

      showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (context, controller) {
          return Flash(
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.bottom,
            boxShadows: kElevationToShadow[4],
            backgroundColor: Colors.blue,
            backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent], ),
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              icon: Icon(iconData),
              content: Text(message),
            ),
          );
        },
      );
    });
  }
}
