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
      'Dona tus kilómetros entre el',
      name: 'donerTitle',
      desc: 'Dona tus kilómetros entre el',
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
      'Podrás donar tus Km en la siguiente edición',
      name: 'donerOutTitle',
      desc: 'donerOutTitle',
      locale: localeName,
    );
  }

  String get doner {
    return Intl.message(
      'Donar',
      name: 'Donar',
      desc: 'Donar',
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
      'Km Donados',
      name: 'donerKm',
      desc: 'Km Donados',
      locale: localeName,
    );
  }

  String get rankingDonerKm {
    return Intl.message(
      'Ranking Km Donados',
      name: 'rankingDonerKm',
      desc: 'Ranking Km Donados',
      locale: localeName,
    );
  }
  
  String get noStravaActivities {
    return Intl.message(
      'No se han encontrado actividades en Strava',
      name: 'noStravaActivities',
      desc: 'noStravaActivities',
      locale: localeName,
    );
  }

  String get rangeOut {
    return Intl.message(
      'Fuera de fecha',
      name: 'rangeOut',
      desc: 'rangeOut',
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