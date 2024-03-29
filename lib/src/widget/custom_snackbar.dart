import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSnackBar {
  void show(
      {required BuildContext context,
        required String? message,
        IconData iconData = FontAwesomeIcons.circleExclamation}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        builder: (context, controller) => Flash(
          controller: controller,
          // behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          // boxShadows: kElevationToShadow[4],
          // backgroundColor: Colors.blue,
          // backgroundGradient: const LinearGradient(
          //   colors: [Colors.blue, Colors.blueAccent],
          // ),
          dismissDirections: const [FlashDismissDirection.startToEnd],
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: FlashBar(
            icon: Icon(iconData),
            content: Text(message!),
            controller: controller,
            backgroundColor: Colors.blue,
            forwardAnimationCurve: Curves.easeInCirc,
            reverseAnimationCurve: Curves.bounceIn,
          ),
        ),
      );
    });
  }
}