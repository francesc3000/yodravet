import 'package:flutter/material.dart';

import '../basic_page.dart';

abstract class RaceBasicPage extends BasicPage {
  RaceBasicPage(String title) : super(title);

  @override
  PreferredSizeWidget appBar(BuildContext context, {String title}) {
    return null;
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
