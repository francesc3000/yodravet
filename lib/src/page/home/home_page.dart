import 'package:yodravet/src/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'home_desktop_page.dart';
import 'home_mobile_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => HomeMobilePage(AppLocalizations.of(context).title),
        ),
        tablet:  OrientationLayoutBuilder(
          portrait: (context) => HomeMobilePage(AppLocalizations.of(context).title),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => HomeDesktopPage(AppLocalizations.of(context).title),
        ),
      );
  }
}