import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';

abstract class LoginBasicPage extends BasicPage {
  const LoginBasicPage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false, bool isFirstTime = false}) =>
      null;

  @override
  Widget? bottomNavigationBar(BuildContext context, {isFirstTime = false}) =>
      null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;
}
