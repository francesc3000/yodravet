import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'privacy_policy_desktop_page.dart';
import 'privacy_policy_mobile_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;
  const PrivacyPolicyPage(this.appRouterDelegate, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ScreenTypeLayout.builder(
        mobile: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => PrivacyPolicyMobilePage(
              AppLocalizations.of(context)!.privacyPolicyTitle,
              appRouterDelegate),
        ),
        tablet: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => PrivacyPolicyMobilePage(
              AppLocalizations.of(context)!.privacyPolicyTitle,
              appRouterDelegate),
        ),
        desktop: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => PrivacyPolicyDesktopPage(
              AppLocalizations.of(context)!.privacyPolicyTitle,
              appRouterDelegate),
        ),
      );
}
