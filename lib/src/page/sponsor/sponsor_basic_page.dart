import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';

abstract class SponsorBasicPage extends BasicPage {
  const SponsorBasicPage(AppRouterDelegate routerDelegate, {Key? key})
      : super("", routerDelegate, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false}) =>
      null;

  @override
  Widget? bottomNavigationBar(BuildContext context) => null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;
}
