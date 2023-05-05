import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'terms_desktop_page.dart';
import 'terms_mobile_page.dart';

class TermsPage extends StatelessWidget {
  final AppRouterDelegate routerDelegate;
  const TermsPage(this.routerDelegate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenTypeLayout.builder(
        mobile: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => TermsMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        tablet: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => TermsMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        desktop: (BuildContext context) => OrientationLayoutBuilder(
          portrait: (context) => TermsDesktopPage(
            routerDelegate,
            key: key,
          ),
        ),
      );
}
