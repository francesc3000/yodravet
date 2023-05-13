import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    MusicIconButton musicIconButton = MusicIconButton(context);
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
        musicIconButton.getMusicIcon(isMusicOn),
        musicIconButton.getPurchaseMusicIcon(),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    Widget? racePage;
    racePage ??= RacePage(routerDelegate);
    Widget? sponsorPage;
    sponsorPage ??= SponsorPage(routerDelegate);
    Widget? donorPage;
    donorPage ??= DonorPage(routerDelegate);
    Widget? rankingPage;
    rankingPage ??= RankingPage(routerDelegate);
    Widget? userPage;
    userPage ??= UserPage(routerDelegate);
    Widget? feedPage;
    feedPage ??= FeedPage(routerDelegate);
    List<Widget?> pages = [
      racePage,
      sponsorPage,
      rankingPage,
      feedPage,
      donorPage,
      userPage
    ];

    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
      int? currentIndex = 0;

      if (state is HomeInitState) {
        BlocProvider.of<AuthBloc>(context).add(AutoLogInEvent());
        BlocProvider.of<HomeBloc>(context).add(HomeInitDataEvent());
      } else if (state is UploadHomeFields) {
        currentIndex = state.index;
      } else if (state is Navigate2UserPageState) {
        return UserPage(routerDelegate);
      }
      return Stack(
        children: [
          Positioned(child: pages[currentIndex]!),
          Positioned(
            child: SideMenu(
              position: SideMenuPosition.right,
              mode: SideMenuMode.compact,
              backgroundColor: const Color.fromRGBO(153, 148, 86, 1),
              builder: (data) => SideMenuData(
                //header: const Text('Header'),
                items: [
                  SideMenuItemDataTile(
                    isSelected: currentIndex == 0,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                        const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(0)),
                    title: 'Mapa',
                    icon: const Icon(FontAwesomeIcons.map),
                  ),
                  SideMenuItemDataTile(
                    isSelected: currentIndex == 1,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                        const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(1)),
                    title: 'Sponsors',
                    icon: const Icon(FontAwesomeIcons.handshakeAngle),
                  ),
                  SideMenuItemDataTile(
                    isSelected: currentIndex == 2,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                    const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(2)),
                    title: 'Ranking',
                    icon: const Icon(FontAwesomeIcons.rankingStar),
                  ),
                  SideMenuItemDataTile(
                    isSelected: currentIndex == 3,
                    unSelectedColor: Colors.white,
                    highlightSelectedColor:
                    const Color.fromARGB(255, 140, 71, 153),
                    onTap: () => BlocProvider.of<HomeBloc>(context)
                        .add(ChangeTabEvent(3)),
                    title: 'Noticias',
                    icon: const Icon(FontAwesomeIcons.rss),
                  ),
                  SideMenuItemDataTile(
                    isSelected: currentIndex == 5,
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
