import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';
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
