import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';
import '../login/login_page.dart';

abstract class HomeBasicPage extends BasicPage {
  const HomeBasicPage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  PreferredSizeWidget appBar(BuildContext context, {String? title}) {
    if (PlatformDiscover.isWeb()) {
      return AppBar(
        title: Container(
          // color: Color.fromRGBO(177, 237, 100, 93),
          alignment: Alignment.centerLeft,
          child: Text(
            title!,
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 58),
          ),
        ),
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(153, 148, 86, 60),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.userCircle),
            tooltip: AppLocalizations.of(context)!.userTooltip,
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(Navigate2UserPageEvent());
            },
          ),
        ],
      );
    } else {
      return AppBar(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/race/logoYoCorro.png'),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            height: 50,
            width: 50,
          ),
        ),
        title: Text(title!),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.userCircle),
            tooltip: AppLocalizations.of(context)!.userTooltip,
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(Navigate2UserPageEvent());
            },
          ),
          // RawMaterialButton(
          //   onPressed: () {
          //     BlocProvider.of<HomeBloc>(context)
          //     .add(Navigate2UserPageEvent());
          //   },
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(100),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           image: AssetImage('assets/images/race/logoYoCorro.png'),
          //         ),
          //         borderRadius: BorderRadius.all(Radius.circular(10)),
          //       ),
          //       height: 50,
          //       width: 50,
          //     ),
          //   ),
          //   shape: CircleBorder(),
          // ),
        ],
      );
    }
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) => null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;
}
