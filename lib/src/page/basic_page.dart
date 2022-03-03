import 'package:flutter/material.dart';

import '../route/app_router_delegate.dart';

abstract class BasicPage extends StatelessWidget {
  final String title;
  final AppRouterDelegate routerDelegate;

  const BasicPage(this.title, this.routerDelegate, {Key? key})
      : super(key: key);

  PreferredSizeWidget? appBar(BuildContext context, {String? title});
  Widget body(BuildContext context);
  Widget? floatingActionButton(BuildContext context);
  Widget? bottomNavigationBar(BuildContext context);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: appBar(context, title: title),
          body: body(context),
          floatingActionButton: floatingActionButton(context),
          bottomNavigationBar: bottomNavigationBar(context),
        ),
      );
}
