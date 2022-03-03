import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';
import 'package:yodravet/src/page/login/login_page.dart';
import 'package:yodravet/src/page/race/race_page.dart';

import '../../route/app_router_delegate.dart';
import '../test_page.dart';
import 'home_basic_page.dart';

class HomeMobilePage extends HomeBasicPage {
  const HomeMobilePage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key}) : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    Widget _racePage = RacePage(routerDelegate);
    List<Widget> _pages = [
      _racePage,
    ];

    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
      int? _currentIndex = 0;

      if (state is HomeInitState) {
        BlocProvider.of<AuthBloc>(context).add(AutoLogInEvent());
      } else if (state is UploadHomeFields) {
        _currentIndex = state.index;
      } else if (state is Navigate2UserPageState) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          BlocProvider.of<HomeBloc>(context).add(HomeStaticEvent());
          routerDelegate.pushPageAndRemoveUntil(name: '/userPage');
        });
      } else if (state is Navigate2LoginState) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          // showModalBottomSheet(
          //     context: context,
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          //     ),
          //     builder: (BuildContext bc) => Container(
          //         child: LoginPage(routerDelegate),
          //         alignment: Alignment.bottomCenter,
          //         height: MediaQuery.of(context).copyWith().size.height,
          //       ));
        routerDelegate.pushPage(name: "/loginPage");
          // BlocProvider.of<HomeBloc>(context).add(Navigate2LoginSuccessEvent());
        });
      }
      return _pages[_currentIndex!];
    });
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) => null;
}
