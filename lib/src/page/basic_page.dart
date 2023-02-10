import 'package:flutter/material.dart';

import '../route/app_router_delegate.dart';

abstract class BasicPage extends StatelessWidget {
  final String title;
  final AppRouterDelegate routerDelegate;
  final bool isMusicOn;
  final bool isFirstTime;

  const BasicPage(this.title, this.routerDelegate,
      {Key? key, this.isMusicOn = false, this.isFirstTime = false})
      : super(key: key);

  PreferredSizeWidget? appBar(BuildContext context,
      {String? title, bool isMusicOn = false, bool isFirstTime = false});
  Widget body(BuildContext context);
  Widget? floatingActionButton(BuildContext context);
  FloatingActionButtonLocation? floatingActionButtonLocation(
      BuildContext context);
  Widget? bottomNavigationBar(BuildContext context, {bool isFirstTime = false});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: appBar(context,
              title: title, isMusicOn: isMusicOn, isFirstTime: isFirstTime),
          body: body(context),
          floatingActionButton: floatingActionButton(context),
          floatingActionButtonLocation: floatingActionButtonLocation(context),
          bottomNavigationBar:
              bottomNavigationBar(context, isFirstTime: isFirstTime),
        ),
      );
}
