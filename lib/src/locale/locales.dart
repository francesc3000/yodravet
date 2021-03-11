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