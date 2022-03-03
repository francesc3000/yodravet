import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'home_desktop_page.dart';
import 'home_mobile_page.dart';

class HomePage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;
  const HomePage(this.appRouterDelegate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => HomeMobilePage(
              AppLocalizations.of(context)!.title, appRouterDelegate),
        ),
        tablet: OrientationLayoutBuilder(
          portrait: (context) => HomeMobilePage(
              AppLocalizations.of(context)!.title, appRouterDelegate),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => HomeDesktopPage(
              AppLocalizations.of(context)!.title, appRouterDelegate),
        ),
      );
}
