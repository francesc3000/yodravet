import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'login_desktop_page.dart';
import 'login_mobile_page.dart';

class LoginPage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;
  const LoginPage(this.appRouterDelegate, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) => ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => LoginMobilePage(
              AppLocalizations.of(context)!.loginTitle, appRouterDelegate),
        ),
        tablet: OrientationLayoutBuilder(
          portrait: (context) => LoginMobilePage(
              AppLocalizations.of(context)!.loginTitle, appRouterDelegate),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => LoginDesktopPage(
              AppLocalizations.of(context)!.loginTitle, appRouterDelegate),
        ),
      );
}
