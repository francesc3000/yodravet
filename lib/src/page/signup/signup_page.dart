import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'signup_desktop_page.dart';
import 'signup_mobile_page.dart';

class SignupPage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;
  const SignupPage(this.appRouterDelegate, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) => ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => SignupMobilePage(
              AppLocalizations.of(context)!.signIn, appRouterDelegate),
        ),
        tablet: OrientationLayoutBuilder(
          portrait: (context) => SignupMobilePage(
              AppLocalizations.of(context)!.signIn, appRouterDelegate),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => SignupDesktopPage(
              AppLocalizations.of(context)!.signIn, appRouterDelegate),
        ),
      );
}
