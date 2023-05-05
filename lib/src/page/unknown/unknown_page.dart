import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'unknown_desktop_page.dart';
import 'unknown_mobile_page.dart';

class UnknownPage extends StatelessWidget {
  final AppRouterDelegate routerDelegate;
  const UnknownPage(this.routerDelegate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenTypeLayout.builder(
        mobile: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => UnknownMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        tablet: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => UnknownMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        desktop: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => UnknownDesktopPage(
            routerDelegate,
            key: key,
          ),
        ),
      );
}
