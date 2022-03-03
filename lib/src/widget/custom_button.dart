import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final Color color;

  const CustomButton(
      {Key? key, this.onPressed, this.child, this.color = Colors.blue})
      : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
          elevation: 6.0,
          child: MaterialButton(
            child: child,
            minWidth: 200.0,
            height: 45.0,
            onPressed: onPressed,
          ),
        ),
      );
}
