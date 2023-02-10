import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../route/app_router_delegate.dart';
import 'privacy_policy_basic_page.dart';

class PrivacyPolicyDesktopPage extends PrivacyPolicyBasicPage {
  const PrivacyPolicyDesktopPage(
      String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false, bool isFirstTime = false}) =>
      null;

  @override
  Widget body(BuildContext context) => SafeArea(
        // child: Text(AppLocalizations.of(context).privacyPolicy,),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!.privacyPolicyTitle}\n',
                    style: const TextStyle(
                        fontSize: 30.0, decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                      text:
                          '${AppLocalizations.of(context)!
                              .privacyPolicyParagraph1}\n\n\n'),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle2}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                      text:
                          '${AppLocalizations.of(context)!
                              .privacyPolicyParagraph2} ',
                      children: [
                        TextSpan(
                            text: 'Google Play Services\n\n',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                var uri = Uri.parse(
                                    "https://www.google.com/policies/privacy/");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  var text = uri.path;
                                  throw 'Could not launch $text';
                                }
                              }),
                      ]),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle3}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyParagraph3}\n\n\n',
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle4}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyParagraph4}\n\n\n',
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle5}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyParagraph5}\n\n\n',
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle6}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyParagraph6}\n\n\n',
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle7}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyParagraph7}\n\n\n',
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle8}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyParagraph8}\n\n\n',
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle9}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyParagraph9}\n\n\n',
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyTitle10}\n',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context)!
                            .privacyPolicyParagraph10}\n\n\n',
                  ),
                ]),
              ),
            ],
          ),
        ),
      );
}
