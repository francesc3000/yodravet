import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';

abstract class HomeBasicPage extends BasicPage {
  const HomeBasicPage(String title, AppRouterDelegate appRouterDelegate,
      bool isMusicOn, bool isFirstTime, {Key? key})
      : super(title, appRouterDelegate,
            key: key, isMusicOn: isMusicOn, isFirstTime: isFirstTime);

  @override
  Widget? bottomNavigationBar(BuildContext context, {isFirstTime = false}) =>
      null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  FloatingActionButtonLocation? floatingActionButtonLocation(
      BuildContext context) => null;
}
