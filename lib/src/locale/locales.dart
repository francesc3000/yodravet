import 'package:yodravet/src/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This file was generated in two steps, using the Dart intl tools. With the
// app's root directory (the one that contains pubspec.yaml) as the current
// directory:
//
// flutter pub get
// flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/src/l10n lib/src/locale/locales.dart
// flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/src/l10n --no-use-deferred-loading lib/src/l10n/intl_en.arb lib/src/l10n/intl_es.arb lib/src/locale/locales.dart
//
// The second command generates intl_messages.arb and the third generates
// messages_all.dart. There's more about this process in
// https://pub.dev/packages/intl.

class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode != null ? locale.countryCode.isEmpty ? locale.languageCode : locale.toString()
                                                    : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;

  String get title {
    return Intl.message(
      'A.E. Yo corro por el Dravet',
      name: 'title',
      desc: 'Title for the App application',
      locale: localeName,
    );
  }

  String get userTooltip {
    return Intl.message(
      'User',
      name: 'userTooltip',
      desc: 'userTooltip for the App application',
      locale: localeName,
    );
  }

  String get loginTitle {
    return Intl.message(
      'Login',
      name: 'loginTitle',
      desc: 'loginTitle for the App application',
      locale: localeName,
    );
  }

  String get logInO {
    return Intl.message(
      'O inicia sesión con tu correo electrónico',
      name: 'signInO',
      desc: 'signInO',
      locale: localeName,
    );
  }

  String get logIn {
    return Intl.message(
      'Iniciar Sesión',
      name: 'signIn',
      desc: 'signIn',
      locale: localeName,
    );
  }
  
  String get stageTitle {
    return Intl.message(
      'Km Etapa',
      name: 'stageTitle',
      desc: 'stageTitle',
      locale: localeName,
    );
  }

  String get totalTitle {
    return Intl.message(
      'Km Totales',
      name: 'totalTitle',
      desc: 'totalTitle',
      locale: localeName,
    );
  }

  String get extraTitle {
    return Intl.message(
      'Km Acumulado',
      name: 'extraTitle',
      desc: 'extraTitle',
      locale: localeName,
    );
  }

  String get signIn {
    return Intl.message(
      'Registrarme',
      name: 'signIn',
      desc: 'Registrarme',
      locale: localeName,
    );
  }

  String get logOut {
    return Intl.message(
      'Cerrar Sesión',
      name: 'logOut',
      desc: 'logOut',
      locale: localeName,
    );
  }

  String get stravaConnect {
    return Intl.message(
      'Conectar con Strava',
      name: 'stravaConnect',
      desc: 'Conectar con Strava',
      locale: localeName,
    );
  }
  
  String get donerTitle {
    return Intl.message(
      'Sube tus kilómetros entre el',
      name: 'donerTitle',
      desc: 'Sube tus kilómetros entre el',
      locale: localeName,
    );
  }
  
  String get donerMiddleTitle {
    return Intl.message(
      ' y el ',
      name: 'donerMiddleTitle',
      desc: 'donerMiddleTitle',
      locale: localeName,
    );
  }
  
  String get donerOutTitle {
    return Intl.message(
      'Podrás subir tus Km en la siguiente edición',
      name: 'donerOutTitle',
      desc: 'donerOutTitle',
      locale: localeName,
    );
  }

  String get doner {
    return Intl.message(
      'Subir',
      name: 'Subir',
      desc: 'Subir',
      locale: localeName,
    );
  }

  String get manualKm {
    return Intl.message(
      'Km manuales',
      name: 'manualKm',
      desc: 'km manuales',
      locale: localeName,
    );
  }

  String get donerKm {
    return Intl.message(
      'Km Subidos',
      name: 'donerKm',
      desc: 'Km Subidos',
      locale: localeName,
    );
  }

  String get rankingDonerKm {
    return Intl.message(
      'Ranking Km Subidos',
      name: 'rankingDonerKm',
      desc: 'Ranking Km Subidos',
      locale: localeName,
    );
  }
  
  String get noStravaActivities {
    return Intl.message(
      '¡Aún no has subido ninguna actividad!',
      name: 'noStravaActivities',
      desc: 'noStravaActivities',
      locale: localeName,
    );
  }

  String get rangeOut {
    return Intl.message(
      '¡Gracias por tu colaboración!\nNos vemos en la próxima edición.',
      name: 'rangeOut',
      desc: 'rangeOut',
      locale: localeName,
    );
  }

  String get beforeRange {
    return Intl.message(
      'Podrás subir km a partir del',
      name: 'beforeRange',
      desc: 'beforeRange',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle {
    return Intl.message(
      'Privacy Policy\n',
      name: 'privacyPolicyTitle',
      desc: 'privacyPolicyTitle',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph1 {
    return Intl.message(
      'Yo corro por el dravet built the Yo Dravet app as a Commercial app. This SERVICE is provided by Yo corro por el dravet and is intended for use as is.\n\nThis page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.\n\nIf you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Yo Dravet unless otherwise defined in this Privacy Policy.',
      name: 'privacyPolicyParagraph1',
      desc: 'privacyPolicyParagraph1',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle2 {
    return Intl.message(
      'Information Collection and Use',
      name: 'privacyPolicyTitle2',
      desc: 'privacyPolicyTitle2',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph2 {
    return Intl.message(
      'For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to email, full name. The information that we request will be retained by us and used as described in this privacy policy.\n\nThe app does use third party services that may collect information used to identify you.\n\nLink to privacy policy of third party service providers used by the app',
      name: 'privacyPolicyParagraph2',
      desc: 'privacyPolicyParagraph2',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle3 {
    return Intl.message(
      'Log Data',
      name: 'privacyPolicyTitle3',
      desc: 'privacyPolicyTitle3',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph3 {
    return Intl.message(
      'We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.',
      name: 'privacyPolicyParagraph3',
      desc: 'privacyPolicyParagraph3',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle4 {
    return Intl.message(
      'Cookies',
      name: 'privacyPolicyTitle4',
      desc: 'privacyPolicyTitle4',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph4 {
    return Intl.message(
      'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device\'s internal memory.\n\nThis Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.',
      name: 'privacyPolicyParagraph4',
      desc: 'privacyPolicyParagraph4',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle5 {
    return Intl.message(
      'Service Providers',
      name: 'privacyPolicyTitle5',
      desc: 'privacyPolicyTitle5',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph5 {
    return Intl.message(
      'We may employ third-party companies and individuals due to the following reasons:\n*   To facilitate our Service;\n*   To provide the Service on our behalf;\n*   To perform Service-related services; or\n*   To assist us in analyzing how our Service is used.\n\nWe want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.',
      name: 'privacyPolicyParagraph5',
      desc: 'privacyPolicyParagraph5',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle6 {
    return Intl.message(
      'Security',
      name: 'privacyPolicyTitle6',
      desc: 'privacyPolicyTitle6',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph6 {
    return Intl.message(
      'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.',
      name: 'privacyPolicyParagraph6',
      desc: 'privacyPolicyParagraph6',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle7 {
    return Intl.message(
      'Links to Other Sites',
      name: 'privacyPolicyTitle7',
      desc: 'privacyPolicyTitle7',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph7 {
    return Intl.message(
      'This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.',
      name: 'privacyPolicyParagraph7',
      desc: 'privacyPolicyParagraph7',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle8 {
    return Intl.message(
      'Children’s Privacy',
      name: 'privacyPolicyTitle8',
      desc: 'privacyPolicyTitle8',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph8 {
    return Intl.message(
      'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.',
      name: 'privacyPolicyParagraph8',
      desc: 'privacyPolicyParagraph8',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle9 {
    return Intl.message(
      'Changes to This Privacy Policy',
      name: 'privacyPolicyTitle9',
      desc: 'privacyPolicyTitle9',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph9 {
    return Intl.message(
      'We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n  This policy is effective as of 2021-04-28',
      name: 'privacyPolicyParagraph9',
      desc: 'privacyPolicyParagraph9',
      locale: localeName,
    );
  }

  String get privacyPolicyTitle10 {
    return Intl.message(
      'Contact Us',
      name: 'privacyPolicyTitle10',
      desc: 'privacyPolicyTitle10',
      locale: localeName,
    );
  }

  String get privacyPolicyParagraph10 {
    return Intl.message(
      'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at yocorroytu2722@gmail.com.',
      name: 'privacyPolicyParagraph10',
      desc: 'privacyPolicyParagraph10',
      locale: localeName,
    );
  }

  String get leftDayTitle {
    return Intl.message(
      'Días Fin Etapa:',
      name: 'privacyPolicyParagraph10',
      desc: 'privacyPolicyParagraph10',
      locale: localeName,
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  // bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}