import 'package:flutter/material.dart';

import '../../route/app_router_delegate.dart';
import 'unknown_basic_page.dart';

class UnknownMobilePage extends UnknownBasicPage {
  const UnknownMobilePage(AppRouterDelegate routerDelegate, {Key? key})
      : super(routerDelegate, key: key);

  @override
  Widget body(BuildContext context) =>
      const Scaffold(body: Text("Error. Pagina no encontrada"));
}
