import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';
import 'package:yodravet/src/page/donor/donor_page.dart';
import 'package:yodravet/src/page/home/widget/music_icon_button.dart';
import 'package:yodravet/src/page/intro/intro_mobile_page.dart';
import 'package:yodravet/src/page/race/race_page.dart';
import 'package:yodravet/src/page/ranking/ranking_page.dart';
import 'package:yodravet/src/page/sponsor/sponsor_page.dart';
import 'package:yodravet/src/page/user/user_page.dart';

import '../../route/app_router_delegate.dart';
import 'home_basic_page.dart';

class HomeMobilePage extends HomeBasicPage {
  const HomeMobilePage(String title, AppRouterDelegate appRouterDelegate,
      bool isMusicOn, bool isFirstTime,
      {Key? key})
      : super(title, appRouterDelegate, isMusicOn, isFirstTime, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
      {String? title, bool isFirstTime = false, bool isMusicOn = false}) {
    MusicIconButton _musicIconButton = MusicIconButton(context);
    return isFirstTime
        ? null
        : AppBar(
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
              _musicIconButton.getMusicIcon(isMusicOn),
              IconButton(
                  onPressed: () =>
                      BlocProvider.of<HomeBloc>(context).add(ChangeTabEvent(5)),
                  icon: const Icon(FontAwesomeIcons.solidUser))
            ],
          );
  }

  @override
  Widget body(BuildContext context) {
    Widget? _racePage;
    _racePage ??= RacePage(routerDelegate);
    Widget? _sponsorPage;
    _sponsorPage ??= SponsorPage(routerDelegate);
    Widget? _donorPage;
    _donorPage ??= DonorPage(routerDelegate);
    Widget? _rankingPage;
    _rankingPage ??= RankingPage(routerDelegate);
    Widget? _userPage;
    _userPage ??= UserPage(routerDelegate);
    List<Widget?> _pages = [
      _racePage,
      _sponsorPage,
      _rankingPage,
      _userPage,
      _donorPage,
      _userPage
    ];

    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
      int? _currentIndex = 0;
      bool _firstTime = false;
      bool _loading = false;

      if (state is HomeInitState) {
        _loading = true;
        BlocProvider.of<AuthBloc>(context).add(AutoLogInEvent());
        BlocProvider.of<HomeBloc>(context).add(HomeInitDataEvent());
      } else if (state is UploadHomeFields) {
        _loading = false;
        _currentIndex = state.index;
        _firstTime = state.isFirstTime;
      }

      if (_loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_firstTime) {
        return IntroMobilePage(routerDelegate);
      }

      return _pages[_currentIndex]!;
    });
  }

  @override
  Widget? floatingActionButton(BuildContext context) => FloatingActionButton(
      child: const Icon(FontAwesomeIcons.personRunning),
      backgroundColor: const Color.fromARGB(255, 140, 71, 153),
      onPressed: () =>
          BlocProvider.of<HomeBloc>(context).add(ChangeTabEvent(4)));

  @override
  FloatingActionButtonLocation? floatingActionButtonLocation(
          BuildContext context) =>
      FloatingActionButtonLocation.centerDocked;

  @override
  Widget? bottomNavigationBar(BuildContext context,
      {bool isFirstTime = false}) {
    // List<BottomNavigationBarItem> items = [];
    //
    // items.add(BottomNavigationBarItem(
    //     icon: const Icon(FontAwesomeIcons.map),
    //     label: AppLocalizations.of(context)!.map));
    // items.add(BottomNavigationBarItem(
    //     icon: const Icon(FontAwesomeIcons.handshakeAngle),
    //     label: AppLocalizations.of(context)!.sponsors));
    // items.add(BottomNavigationBarItem(
    //     icon: const Icon(FontAwesomeIcons.rankingStar),
    //     label: AppLocalizations.of(context)!.sponsors));
    // items.add(BottomNavigationBarItem(
    //     icon: const Icon(FontAwesomeIcons.personRunning),
    //     label: AppLocalizations.of(context)!.kmDonor));

    List<IconData> iconList = [
      FontAwesomeIcons.map,
      FontAwesomeIcons.handshakeAngle,
      FontAwesomeIcons.rankingStar,
      FontAwesomeIcons.rss,
    ];

    return isFirstTime
        ? null
        : BlocBuilder<HomeBloc, HomeState>(
            builder: (BuildContext context, state) {
            int _currentIndex = 0;
            if (state is UploadHomeFields) {
              _currentIndex = state.index;
            }

            // return BottomNavigationBar(
            //   items: items,
            //   // backgroundColor: Colors.black,
            //   // fixedColor: Colors.white,
            //   // unselectedItemColor: Colors.grey,
            //   // backgroundColor: const Color.fromARGB(255, 140, 71, 153),
            //   currentIndex: _currentIndex,
            //   onTap: (int index) {
            //     _currentIndex = index;
            //     BlocProvider.of<HomeBloc>(context)
            //     .add(ChangeTabEvent(index));
            //   },
            // );
            return Container(
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: AnimatedBottomNavigationBar(
                icons: iconList,
                activeIndex: _currentIndex,
                gapLocation: GapLocation.center,
                backgroundColor: const Color.fromARGB(255, 140, 71, 153),
                activeColor: Colors.white,
                splashColor: Colors.grey,
                notchSmoothness: NotchSmoothness.verySmoothEdge,
                leftCornerRadius: 32,
                rightCornerRadius: 32,
                onTap: (index) {
                  _currentIndex = index;
                  BlocProvider.of<HomeBloc>(context).add(ChangeTabEvent(index));
                },
                //other params
              ),
            );
          });
  }
}
