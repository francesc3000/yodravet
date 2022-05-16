import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uni_links/uni_links.dart';

import '../route/app_route_information_parser.dart';
import '../route/app_router_delegate.dart';

/// The Widget that configures your application.
class App extends StatefulWidget {
  final AppRouterDelegate myRouterDelegate;

  const App(
      this.myRouterDelegate, {
        Key? key,
      }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouterDelegate routerDelegate;
  late StreamSubscription _linkSubscription;
  @override
  void initState() {
    super.initState();
    routerDelegate = widget.myRouterDelegate;
    routerDelegate.pushPage(name: '/');
    // only handle deep links on mobile
    if (!kIsWeb) initialize();

    // initializeDateFormatting();
  }

  @override
  void dispose() {
    _linkSubscription.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    // try {
    // Get the link that launched the app
    final initialUri = await getInitialUri();
    if (initialUri != null) routerDelegate.parseRoute(initialUri);
    // } on FormatException catch (error) {
    // print(error);
    // }
    // Attach a listener to the uri_links stream
    _linkSubscription = uriLinkStream.listen((uri) {
      if (!mounted) return;
      routerDelegate.parseRoute(uri!);
    }, onError: (error) => error.printError());
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    // Providing a restorationScopeId allows the Navigator built by the
    // MaterialApp to restore the navigation stack when a user leaves and
    // returns to the app after it has been killed while running in the
    // background.
    // restorationScopeId: 'app',

    // Provide the generated AppLocalizations to the MaterialApp. This
    // allows descendant Widgets to display the correct translations
    // depending on the user's locale.
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', ''), // English, no country code
      Locale('es', ''),
      Locale('ca', ''),
    ],

    // Use AppLocalizations to configure the correct application title
    // depending on the user's locale.
    //
    // The appTitle is defined in .arb files found in the localization
    // directory.
    onGenerateTitle: (BuildContext context) =>
    AppLocalizations.of(context)!.title,

    // Define a function to handle named routes in order to support
    // Flutter web url navigation and deep linking.
    // onGenerateRoute: generateRoute,
    theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 140, 71, 153),
      fontFamily: 'AkayaTelivigala'
    ),
    // initialRoute: '/',
    // navigatorKey: navigationService.navigatorKey,
    routerDelegate: routerDelegate,
    routeInformationParser: const AppRouteInformationParser(),
  );
}
