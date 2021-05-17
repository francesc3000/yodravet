import 'package:flutter/material.dart';
import 'package:yodravet/src/locale/locales.dart';

import 'privacy_policy_basic_page.dart';

class PrivacyPolicyMobilePage extends PrivacyPolicyBasicPage {
  PrivacyPolicyMobilePage(String title) : super(title);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(24.0),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(text: AppLocalizations.of(context).privacyPolicyTitle),
            TextSpan(
                text: AppLocalizations.of(context).privacyPolicyParagraph1),
            TextSpan(
                text: AppLocalizations.of(context).privacyPolicyParagraph2),
          ]),
        ),
      ),
    );
  }

}
