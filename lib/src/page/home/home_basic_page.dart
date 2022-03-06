import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

import '../../route/app_router_delegate.dart';
import '../basic_page.dart';

abstract class HomeBasicPage extends BasicPage {
  const HomeBasicPage(
      String title, AppRouterDelegate appRouterDelegate, bool isMusicOn,
      {Key? key})
      : super(title, appRouterDelegate, key: key, isMusicOn: isMusicOn);

  @override
  PreferredSizeWidget appBar(BuildContext context,
      {String? title, bool isMusicOn = false}) {
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
        backgroundColor: const Color.fromARGB(255, 140, 71, 153),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.home),
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(HomeStaticEvent());
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.userCircle),
            tooltip: AppLocalizations.of(context)!.userTooltip,
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(Navigate2UserPageEvent());
            },
          ),
          _musicIconButton(context, isMusicOn),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: const Color.fromARGB(255, 140, 71, 153),
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
          // IconButton(
          //   icon: const Icon(FontAwesomeIcons.userCircle),
          //   tooltip: AppLocalizations.of(context)!.userTooltip,
          //   onPressed: () {
          //     BlocProvider.of<HomeBloc>(context)
          //     .add(Navigate2UserPageEvent());
          //   },
          // ),
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
          _musicIconButton(context, isMusicOn),
        ],
      );
    }
  }

  Widget _musicIconButton(BuildContext context, bool isMusicOn) => IconButton(
        onPressed: () {
          BlocProvider.of<HomeBloc>(context).add(ChangeMuteOptionEvent());
        },
        icon: isMusicOn
            ? const Icon(FontAwesomeIcons.music)
            : const Icon(FontAwesomeIcons.pause),
      );

  @override
  Widget? bottomNavigationBar(BuildContext context) => null;

  @override
  Widget? floatingActionButton(BuildContext context) => null;
}
