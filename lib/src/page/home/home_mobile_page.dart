import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';
import 'package:yodravet/src/page/login/login_page.dart';
import 'package:yodravet/src/page/race/race_page.dart';
import 'package:yodravet/src/routes/route_name.dart';

import 'home_basic_page.dart';

class HomeMobilePage extends HomeBasicPage {
  HomeMobilePage(String title) : super(title);

  @override
  Widget body(BuildContext context) {
    Widget _racePage = RacePage();
    List<Widget> _pages = [
      _racePage,
    ];

    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
      int _currentIndex = 0;

      if (state is HomeInitState) {
        BlocProvider.of<AuthBloc>(context).add(AutoLogInEvent());
      } else if (state is UploadHomeFields) {
        _currentIndex = state.index;
      } else if (state is Navigate2UserPageState) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/' + RouteName.userPage);
        });
      } else if (state is Navigate2LoginState) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              builder: (BuildContext bc) {
                return Container(
                  child: LoginPage(),
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).copyWith().size.height,
                );
              });
        });
      }
      return _pages[_currentIndex];
    });
  }

  @override
  Widget bottomNavigationBar(BuildContext context) {
    // List<BottomNavigationBarItem> items = [];

    // items.add(
    //     BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: '1'));
    // items.add(
    //     BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.adn), label: '2'));
    // items.add(BottomNavigationBarItem(
    //     icon: Icon(FontAwesomeIcons.dizzy), label: '3'));

    // return BlocBuilder<HomeBloc, HomeState>(
    //     builder: (BuildContext context, state) {
    //   int _currentIndex = 0;
    //   if (state is UploadHomeFields) {
    //     _currentIndex = state.index;
    //   }

    //   return BottomNavigationBar(
    //     items: items,
    //     currentIndex: _currentIndex,
    //     onTap: (int index) {
    //       _currentIndex = index;
    //       BlocProvider.of<HomeBloc>(context).add(ChangeTabEvent(index));
    //     },
    //   );
    // });
    return null;
  }
}
