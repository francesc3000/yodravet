import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'race_desktop_page.dart';
import 'race_mobile_page.dart';

class RacePage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;
  const RacePage(this.appRouterDelegate, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => RaceMobilePage('', appRouterDelegate),
          landscape: (context) =>
              RaceMobilePage('', appRouterDelegate, isPortrait: false),
        ),
        tablet: OrientationLayoutBuilder(
          portrait: (context) => RaceMobilePage('', appRouterDelegate),
          landscape: (context) => RaceDesktopPage('', appRouterDelegate),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => RaceMobilePage('', appRouterDelegate),
          landscape: (context) => RaceDesktopPage('', appRouterDelegate),
        ),
        // desktop: UnderConstructionPage(),
      );
}
