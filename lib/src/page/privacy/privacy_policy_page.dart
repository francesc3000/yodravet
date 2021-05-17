import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'privacy_policy_desktop_page.dart';
import 'privacy_policy_mobile_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String title;
  const PrivacyPolicyPage({Key key, this.title=''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => PrivacyPolicyMobilePage(title),
        ),
        tablet:  OrientationLayoutBuilder(
          portrait: (context) => PrivacyPolicyMobilePage(title),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => PrivacyPolicyDesktopPage(title),
        ),
      );
  }
}