import 'package:yodravet/src/page/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:yodravet/src/page/signup/signup_page.dart';
import 'package:yodravet/src/page/user/user_page.dart';

import 'route_name.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final List<String> pathElements = settings.name.split('/');

  switch (pathElements[1]) {
    case RouteName.homePage:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomePage(),
      );

    case RouteName.userPage:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UserPage(),
      );
    
    case RouteName.signupPage:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignupPage(),
      );

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
