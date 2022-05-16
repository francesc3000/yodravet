import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';
import 'package:yodravet/src/page/home/widget/music_icon_button.dart';
import 'package:yodravet/src/page/intro/intro_mobile_page.dart';
import 'package:yodravet/src/page/race/race_page.dart';
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
          {String? title, bool isFirstTime = false, bool isMusicOn = false}) =>
      isFirstTime
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
  Widget? bottomNavigationBar(BuildContext context,
      {bool isFirstTime = false}) {
    List<BottomNavigationBarItem> items = [];

    items.add(BottomNavigationBarItem(
        icon: const Icon(FontAwesomeIcons.map),
        label: AppLocalizations.of(context)!.map));
    items.add(BottomNavigationBarItem(
        icon: const Icon(FontAwesomeIcons.handsHelping),
        label: AppLocalizations.of(context)!.sponsors));
    items.add(BottomNavigationBarItem(
        icon: const Icon(FontAwesomeIcons.running),
        label: AppLocalizations.of(context)!.kmDonor));

    return isFirstTime
        ? null
        : BlocBuilder<HomeBloc, HomeState>(
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
