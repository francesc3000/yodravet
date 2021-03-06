import 'package:flutter/material.dart';

import '../basic_page.dart';

abstract class RaceBasicPage extends BasicPage {
  final bool isPortrait;
  RaceBasicPage(String title, {this.isPortrait=true}) : super(title);

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
