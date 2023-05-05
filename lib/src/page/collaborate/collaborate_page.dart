import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'collaborate_desktop_page.dart';
import 'collaborate_mobile_page.dart';

class CollaboratePage extends StatelessWidget {
  final AppRouterDelegate routerDelegate;
  const CollaboratePage(this.routerDelegate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenTypeLayout.builder(
        mobile: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => CollaborateMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        tablet: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => CollaborateMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        desktop: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => CollaborateDesktopPage(
            routerDelegate,
            key: key,
          ),
        ),
      );
}
