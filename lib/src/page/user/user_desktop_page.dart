import 'package:flutter/material.dart';

import 'user_basic_page.dart';

class UserDesktopPage extends UserBasicPage {
  UserDesktopPage(String title) : super(title);

  @override
    Widget body(BuildContext context) {
      return Container(
      child: Text(this.title,
      ),
    );
    }
}