import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'user_desktop_page.dart';
import 'user_mobile_page.dart';

class UserPage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;
  const UserPage(this.appRouterDelegate, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => UserMobilePage('', appRouterDelegate),
        ),
        tablet:  OrientationLayoutBuilder(
          portrait: (context) => UserMobilePage('', appRouterDelegate),
          landscape: (context) => UserDesktopPage('', appRouterDelegate),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => UserMobilePage('', appRouterDelegate),
          landscape: (context) => UserDesktopPage('', appRouterDelegate),
        ),
        // desktop: UnderConstructionPage(),
      );
}