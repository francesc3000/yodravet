import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'signup_desktop_page.dart';
import 'signup_mobile_page.dart';

class SignupPage extends StatelessWidget {
  final String title;
  const SignupPage({Key key, this.title=''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => SignupMobilePage(title),
        ),
        tablet:  OrientationLayoutBuilder(
          portrait: (context) => SignupMobilePage(title),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => SignupDesktopPage(title),
        ),
      );
  }
}