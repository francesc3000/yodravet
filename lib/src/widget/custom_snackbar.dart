import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSnackBar {
  void show(
      {required BuildContext context,
        required String? message,
        IconData iconData = FontAwesomeIcons.exclamationCircle}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        builder: (context, controller) => Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          boxShadows: kElevationToShadow[4],
          backgroundColor: Colors.blue,
          backgroundGradient: const LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
          ),
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            icon: Icon(iconData),
            content: Text(message!),
          ),
        ),
      );
    });
  }
}