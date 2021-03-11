import 'package:flutter/material.dart';

import '../basic_page.dart';

abstract class UserBasicPage extends BasicPage {
  UserBasicPage(String title) : super(title);

  @override
  PreferredSizeWidget appBar(BuildContext context, {String title}) {
    return AppBar(title: Text(title),);
  }

  @override
  Widget bottomNavigationBar(BuildContext context) {
    return null;
  }

  @override
  Widget floatingActionButton(BuildContext context) {
    return null;
  }
}
