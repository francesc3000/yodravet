import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';
import 'package:yodravet/src/page/home/widget/music_icon_button.dart';
import 'package:yodravet/src/page/race/race_page.dart';
import 'package:yodravet/src/page/user/user_page.dart';

import '../../bloc/event/home_event.dart';
import '../../route/app_router_delegate.dart';
import 'home_basic_page.dart';

class HomeDesktopPage extends HomeBasicPage {
  const HomeDesktopPage(
      String title, AppRouterDelegate appRouterDelegate, bool isMusicOn,
      {Key? key})
      : super(title, appRouterDelegate, isMusicOn, key: key);

  @override
  PreferredSizeWidget appBar(BuildContext context,
          {String? title, bool isMusicOn = false}) =>
      AppBar(
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
        // backgroundColor: const Color.fromARGB(255, 140, 71, 153),
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
          MusicIconButton(isMusicOn: isMusicOn),
        ],
      );

  @override
  Widget body(BuildContext context) {
    Widget _racePage = RacePage(routerDelegate);

    List<Widget> _pages = [_racePage];

    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
      int? _currentIndex = 0;

      if (state is HomeInitState) {
        BlocProvider.of<AuthBloc>(context).add(AutoLogInEvent());
        BlocProvider.of<HomeBloc>(context).add(HomeInitDataEvent());
      } else if (state is UploadHomeFields) {
        _currentIndex = state.index;
      } else if (state is Navigate2UserPageState) {
        return UserPage(routerDelegate);
      }
      return _pages[_currentIndex];
    });
  }
}
