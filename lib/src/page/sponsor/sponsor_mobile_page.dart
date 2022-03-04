import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import 'sponsor_basic_page.dart';

class SponsorMobilePage extends SponsorBasicPage {
  const SponsorMobilePage(AppRouterDelegate routerDelegate, {Key? key})
      : super(routerDelegate, key: key);

  @override
  Widget body(BuildContext context) => Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromRGBO(153, 148, 86, 1),
        child: const Center(
          child: Text("Aquí van los Patrocinadores"),
        ),
      );
}
