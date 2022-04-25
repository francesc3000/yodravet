import 'package:flutter/material.dart';
import '../../route/app_router_delegate.dart';
import 'intro_basic_page.dart';

class IntroDesktopPage extends IntroBasicPage {
  const IntroDesktopPage(AppRouterDelegate routerDelegate, {Key? key})
      : super(routerDelegate, key: key);

  @override
  Widget body(BuildContext context) =>
      const Scaffold(body: Text("Desktop no Intro"));
}
