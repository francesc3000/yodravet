import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../route/app_router_delegate.dart';
import 'sponsor_desktop_page.dart';
import 'sponsor_mobile_page.dart';

class SponsorPage extends StatelessWidget {
  final AppRouterDelegate routerDelegate;
  const SponsorPage(this.routerDelegate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => SponsorMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        tablet: OrientationLayoutBuilder(
          portrait: (context) => SponsorMobilePage(
            routerDelegate,
            key: key,
          ),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => SponsorDesktopPage(
            routerDelegate,
            key: key,
          ),
        ),
      );
}
