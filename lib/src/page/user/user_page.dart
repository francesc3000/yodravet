import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'user_desktop_page.dart';
import 'user_mobile_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => UserMobilePage(''),
        ),
        tablet:  OrientationLayoutBuilder(
          portrait: (context) => UserMobilePage(''),
          landscape: (context) => UserDesktopPage(''),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => UserMobilePage(''),
          landscape: (context) => UserDesktopPage(''),
        ),
        // desktop: UnderConstructionPage(),
      );
  }
}