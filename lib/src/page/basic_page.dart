import 'package:flutter/material.dart';

abstract class BasicPage extends StatelessWidget {
  final String title;

  const BasicPage(this.title, {Key key}) : super(key: key);

  PreferredSizeWidget appBar(BuildContext context, {String title});
  Widget body(BuildContext context);
  Widget floatingActionButton(BuildContext context);
  Widget bottomNavigationBar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: title),
        body: body(context),
        floatingActionButton: floatingActionButton(context),
        bottomNavigationBar: bottomNavigationBar(context),
      ),
    );
  }
}
