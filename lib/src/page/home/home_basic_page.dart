import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';

abstract class HomeBasicPage extends BasicPage {
  const HomeBasicPage(
      String title, AppRouterDelegate appRouterDelegate, bool isMusicOn,
      {Key? key})
      : super(title, appRouterDelegate, key: key, isMusicOn: isMusicOn);

  @override
  Widget? bottomNavigationBar(BuildContext context) => null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;
}
