import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';

abstract class SignupBasicPage extends BasicPage {
  const SignupBasicPage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false}) =>
      AppBar(
        title: Text(title!),
      );

  @override
  Widget? bottomNavigationBar(BuildContext context) => null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;
}
