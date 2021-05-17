import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/locale/locales.dart';

import 'privacy_policy_basic_page.dart';

class PrivacyPolicyDesktopPage extends PrivacyPolicyBasicPage {
  PrivacyPolicyDesktopPage(String title) : super(title);

  @override
  PreferredSizeWidget appBar(BuildContext context, {String title}) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      // child: Text(AppLocalizations.of(context).privacyPolicy,),
      child: Container(
        padding: EdgeInsets.all(24.0),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle + '\n',
                  style: TextStyle(
                      fontSize: 30.0, decoration: TextDecoration.underline),
                ),
                TextSpan(
                    text: AppLocalizations.of(context).privacyPolicyParagraph1 +
                        '\n\n\n'),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle2 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                    text:
                        AppLocalizations.of(context).privacyPolicyParagraph2 + ' ',
                    children: [
                      TextSpan(
                          text: 'Google Play Services\n\n',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              var url = "https://www.google.com/policies/privacy/";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }),
                    ]),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle3 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyParagraph3 +
                      '\n\n\n',
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle4 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyParagraph4 +
                      '\n\n\n',
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle5 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyParagraph5 +
                      '\n\n\n',
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle6 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyParagraph6 +
                      '\n\n\n',
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle7 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyParagraph7 +
                      '\n\n\n',
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle8 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyParagraph8 +
                      '\n\n\n',
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle9 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyParagraph9 +
                      '\n\n\n',
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyTitle10 + '\n',
                  style: TextStyle(fontSize: 24.0),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicyParagraph10 +
                      '\n\n\n',
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
