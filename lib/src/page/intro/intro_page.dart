import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'intro_desktop_page.dart';
import 'intro_mobile_page.dart';

class IntroPage extends StatelessWidget {
  final AppRouterDelegate routerDelegate;
  const IntroPage(this.routerDelegate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenTypeLayout.builder(
        mobile: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => IntroMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        tablet: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => IntroMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        desktop: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => IntroDesktopPage(
            routerDelegate,
            key: key,
          ),
        ),
      );
}
