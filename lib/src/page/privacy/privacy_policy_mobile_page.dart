import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../route/app_router_delegate.dart';
import 'privacy_policy_basic_page.dart';

class PrivacyPolicyMobilePage extends PrivacyPolicyBasicPage {
  const PrivacyPolicyMobilePage(
      String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(text: AppLocalizations.of(context)!.privacyPolicyTitle),
              TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicyParagraph1),
              TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicyParagraph2),
            ]),
          ),
        ),
      );
}
