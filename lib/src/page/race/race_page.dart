import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'race_desktop_page.dart';
import 'race_mobile_page.dart';

class RacePage extends StatelessWidget {
  const RacePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => RaceMobilePage(''),
          landscape: (context) => RaceMobilePage('', isPortrait: false),
        ),
        tablet:  OrientationLayoutBuilder(
          portrait: (context) => RaceMobilePage(''),
          landscape: (context) => RaceDesktopPage(''),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => RaceMobilePage(''),
          landscape: (context) => RaceDesktopPage(''),
        ),
        // desktop: UnderConstructionPage(),
      );
  }
}