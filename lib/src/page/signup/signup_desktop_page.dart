import 'package:flutter/material.dart';

import 'signup_basic_page.dart';

class SignupDesktopPage extends SignupBasicPage {
  SignupDesktopPage(String title) : super(title);

  @override
    Widget body(BuildContext context) {
      return Container(
      child: Text(this.title,
      ),
    );
    }
}