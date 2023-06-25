import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformDiscover {
  static bool isWeb() => kIsWeb;

  static bool isMacOs(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.macOS;

  static bool isIOs(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.iOS;
}
