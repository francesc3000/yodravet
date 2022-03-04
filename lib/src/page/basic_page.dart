import 'package:flutter/material.dart';

import '../route/app_router_delegate.dart';

abstract class BasicPage extends StatelessWidget {
  final String title;
  final AppRouterDelegate routerDelegate;
  final bool isMusicOn;

  const BasicPage(this.title, this.routerDelegate,
      {Key? key, this.isMusicOn = false})
      : super(key: key);

  PreferredSizeWidget? appBar(BuildContext context,
      {String? title, bool isMusicOn = false});
  Widget body(BuildContext context);
  Widget? floatingActionButton(BuildContext context);
  Widget? bottomNavigationBar(BuildContext context);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: appBar(context, title: title, isMusicOn: isMusicOn),
          body: body(context),
          floatingActionButton: floatingActionButton(context),
          bottomNavigationBar: bottomNavigationBar(context),
        ),
      );
}
