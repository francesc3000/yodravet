import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';

abstract class RaceBasicPage extends BasicPage {
  final bool isPortrait;
  const RaceBasicPage(String title, AppRouterDelegate appRouterDelegate,
      {this.isPortrait = true, Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false}) =>
      null;

  @override
  Widget? bottomNavigationBar(BuildContext context) => null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;
}
