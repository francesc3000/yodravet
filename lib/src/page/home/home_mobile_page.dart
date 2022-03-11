import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';
import 'package:yodravet/src/page/home/widget/music_icon_button.dart';
import 'package:yodravet/src/page/race/race_page.dart';
import 'package:yodravet/src/page/sponsor/sponsor_page.dart';
import 'package:yodravet/src/page/user/user_page.dart';

import '../../route/app_router_delegate.dart';
import 'home_basic_page.dart';

class HomeMobilePage extends HomeBasicPage {
  const HomeMobilePage(
      String title, AppRouterDelegate appRouterDelegate, bool isMusicOn,
      {Key? key})
      : super(title, appRouterDelegate, isMusicOn, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false}) =>
      AppBar(
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
          MusicIconButton(isMusicOn: isMusicOn),
        ],
      );

  @override
  Widget body(BuildContext context) {
    Widget? _racePage;
    _racePage ??= RacePage(routerDelegate);
    Widget? _sponsorPage;
    _sponsorPage ??= SponsorPage(routerDelegate);
    Widget? _userPage;
    _userPage ??= UserPage(routerDelegate);
    List<Widget?> _pages = [_racePage, _sponsorPage, _userPage];

    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
      int? _currentIndex = 0;

      if (state is HomeInitState) {
        BlocProvider.of<AuthBloc>(context).add(AutoLogInEvent());
        BlocProvider.of<HomeBloc>(context).add(HomeInitDataEvent());
      } else if (state is UploadHomeFields) {
        _currentIndex = state.index;
        // } else if (state is Navigate2UserPageState) {
        //   SchedulerBinding.instance!.addPostFrameCallback((_) {
        //     BlocProvider.of<HomeBloc>(context).add(HomeStaticEvent());
        //     routerDelegate.pushPageAndRemoveUntil(name: '/userPage');
        //   });
      }

      return _pages[_currentIndex]!;
    });
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    List<BottomNavigationBarItem> items = [];

    items.add(const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.map), label: 'Mapa'));
    items.add(const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.handsHelping), label: 'Patrocinadores'));
    items.add(const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.running), label: 'Donar Km'));

    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
      int _currentIndex = 0;
      if (state is UploadHomeFields) {
        _currentIndex = state.index;
      }

      return BottomNavigationBar(
        items: items,
        // backgroundColor: Colors.black,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color.fromARGB(255, 140, 71, 153),
        currentIndex: _currentIndex,
        onTap: (int index) {
          _currentIndex = index;
          BlocProvider.of<HomeBloc>(context).add(ChangeTabEvent(index));
        },
      );
    });
  }
}
