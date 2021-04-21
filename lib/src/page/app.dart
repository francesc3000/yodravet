import 'package:yodravet/src/routes/router.dart';
import 'package:yodravet/src/routes/navigation_service.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yodravet/src/locale/locales.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final NavigationService navigationService;
  App(this.navigationService);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        const AppLocalizationsDelegate(),
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(primaryColor: Color.fromRGBO(140, 71, 153, 1), fontFamily: 'AkayaTelivigala' ),
      supportedLocales: [
        const Locale('en'), // English
        // const Locale('es'), // Spanish
      ],
      
      initialRoute: '/',
      navigatorKey: navigationService.navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }
}
