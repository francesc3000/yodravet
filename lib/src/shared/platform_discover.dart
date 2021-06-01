import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformDiscover {
  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMacOs(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.macOS;
  }
}
