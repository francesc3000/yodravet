import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'login_desktop_page.dart';
import 'login_mobile_page.dart';

class LoginPage extends StatelessWidget {
  final String title;
  const LoginPage({Key key, this.title=''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => LoginMobilePage(title),
        ),
        tablet:  OrientationLayoutBuilder(
          portrait: (context) => LoginMobilePage(title),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => LoginDesktopPage(title),
        ),
      );
  }
}