import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';
import 'package:yodravet/src/page/donor/donor_page.dart';
import 'package:yodravet/src/page/feed/feed_page.dart';
import 'package:yodravet/src/page/home/widget/music_icon_button.dart';
import 'package:yodravet/src/page/race/race_page.dart';
import 'package:yodravet/src/page/ranking/ranking_page.dart';
import 'package:yodravet/src/page/sponsor/sponsor_page.dart';
import 'package:yodravet/src/page/user/user_page.dart';

import '../../bloc/event/home_event.dart';
import '../../route/app_router_delegate.dart';
import 'home_basic_page.dart';

class HomeDesktopPage extends HomeBasicPage {
  const HomeDesktopPage(String title, AppRouterDelegate appRouterDelegate,
      bool isMusicOn, bool isFirstTime,
      {Key? key})
      : super(title, appRouterDelegate, isMusicOn, isFirstTime, key: key);

  @override
  PreferredSizeWidget appBar(BuildContext context,
      {String? title, bool isMusicOn = false, bool isFirstTime = false}) {
    MusicIconButton _musicIconButton = MusicIconButton(context);
    return AppBar(
      title: Container(
        // color: Color.fromRGBO(177, 237, 100, 93),
        alignment: Alignment.centerLeft,
        child: Text(
          title!,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 58),
        ),
      ),
      elevation: 0.0,
      backgroundColor: const Color.fromRGBO(153, 148, 86, 60),
      // backgroundColor: const Color.fromARGB(255, 140, 71, 153),
      actions: [
        //IconButton(
          //icon: const Icon(FontAwesomeIcons.house),
          //onPressed: () {
           // BlocProvider.of<HomeBloc>(context).add(HomeStaticEvent());
          //},
        //),
        //IconButton(
          //icon: const Icon(FontAwesomeIcons.circleUser),
          //tooltip: AppLocalizations.of(context)!.userTooltip,
          //onPressed: () {
          //  BlocProvider.of<HomeBloc>(context).add(Navigate2UserPageEvent());
          //},
        //),
        _musicIconButton.getMusicIcon(isMusicOn),
        _musicIconButton.getPurchaseMusicIcon(),
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
    Widget? _feedPage;
    _feedPage ??= FeedPage(routerDelegate);
    List<Widget?> _pages = [
      _racePage,
      _sponsorPage,
      _rankingPage,
      _feedPage,
      _donorPage,
      _userPage
    ];

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
      return Stack(
        children: [
          Positioned(child: _pages[_currentIndex]!),
          Positioned(
            child: SideMenu(
              position: SideMenuPosition.right,
              mode: SideMenuMode.compact,
              backgroundColor: const Color.fromRGBO(153, 148, 86, 1),
              builder: (data) => SideMenuData(
                //header: const Text('Header'),
                items: [
                  SideMenuItemDataTile(
                    isSelected: _currentIndex == 0,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                        const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(0)),
                    title: 'Mapa',
                    icon: const Icon(FontAwesomeIcons.map),
                  ),
                  SideMenuItemDataTile(
                    isSelected: _currentIndex == 1,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                        const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(1)),
                    title: 'Sponsors',
                    icon: const Icon(FontAwesomeIcons.handshakeAngle),
                  ),
                  SideMenuItemDataTile(
                    isSelected: _currentIndex == 2,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                    const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(2)),
                    title: 'Ranking',
                    icon: const Icon(FontAwesomeIcons.rankingStar),
                  ),
                  SideMenuItemDataTile(
                    isSelected: _currentIndex == 3,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                    const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(3)),
                    title: 'Noticias',
                    icon: const Icon(FontAwesomeIcons.rss),
                  ),
                  SideMenuItemDataTile(
                    isSelected: _currentIndex == 5,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                    const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(5)),
                    title: 'Usuario',
                    icon: const Icon(FontAwesomeIcons.user),
                  ),
                ],
                //footer: const Text('Footer'),
              ),
            ),
          ),
        ],
      );
    });
  }
}
