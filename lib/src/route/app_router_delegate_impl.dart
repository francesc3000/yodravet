import 'package:flutter/material.dart';

import '../page/home/home_page.dart';
import '../page/login/login_page.dart';
import '../page/privacy/privacy_policy_page.dart';
import '../page/signup/signup_page.dart';
import '../page/unknown/unknown_page.dart';
import '../page/user/user_page.dart';
import 'app_router_delegate.dart';

class AppRouterDelegateImpl extends AppRouterDelegate {
  @override
  MaterialPage createPage(RouteSettings routeSettings) {
    late Widget child;

    switch (routeSettings.name) {
      case '/':
        child = HomePage(this);
        break;
      case '/userPage':
        child = UserPage(this);
        break;

        case '/signupPage':
        child = SignupPage(this);
        break;

        case '/politica-privacidad':
        child = PrivacyPolicyPage(this);
        break;

        case '/loginPage':
        child = LoginPage(this);
        break;
      default:
        child = UnknownPage(this);
    }
    return MaterialPage(
      child: child,
      key: Key(routeSettings.toString()) as LocalKey,
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }
}
