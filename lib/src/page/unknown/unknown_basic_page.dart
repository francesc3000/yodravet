import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';

abstract class UnknownBasicPage extends BasicPage {
  const UnknownBasicPage(AppRouterDelegate routerDelegate, {Key? key})
      : super("", routerDelegate, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false, bool isFirstTime = false}) =>
      null;

  @override
  Widget? bottomNavigationBar(BuildContext context, {isFirstTime = false}) =>
      null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  FloatingActionButtonLocation? floatingActionButtonLocation(
      BuildContext context) => null;
}
