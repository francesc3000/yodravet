import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/ranking_event.dart';
import 'package:yodravet/src/bloc/ranking_bloc.dart';
import 'package:yodravet/src/bloc/state/ranking_state.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/ranking.dart';

import '../../route/app_router_delegate.dart';
import 'ranking_basic_page.dart';

class RankingDesktopPage extends RankingBasicPage {
  const RankingDesktopPage(
      String title, final AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false, bool isFirstTime = false}) =>
      null;

  @override
  Widget body(BuildContext context) {
    List<Widget> slivers = [];
    int _filterRankingTab = 2;
    List<Ranking> rankings = [];
    List<Ranking> rankingsTeam = [];
    bool _loading = false;

    return BlocBuilder<RankingBloc, RankingState>(
      builder: (BuildContext context, state) {
        if (state is RankingInitState) {
          BlocProvider.of<RankingBloc>(context).add(LoadInitialDataEvent());
          _loading = true;
        } else if (state is UploadRankingFieldsState) {
          _filterRankingTab = state.filterRankingTab;
          rankings = state.rankings ?? [];
          rankingsTeam = state.rankingsTeam ?? [];
          _loading = false;
        }

        if (_loading) {
          return Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: const Center(child: CircularProgressIndicator()));
        }

        slivers.clear();
        slivers.add(_buildRankingsList(context, _filterRankingTab,
            AppLocalizations.of(context)!.rankingDonerKm, rankings));
        slivers.add(_buildRankingsList(context, _filterRankingTab,
            AppLocalizations.of(context)!.rankingDonerTeamKm, rankingsTeam));

        return Container(
          color: const Color.fromRGBO(153, 148, 86, 1),
          padding: const EdgeInsets.only(left: 50.0, right: 8.0, bottom: 30.0),
          child: CustomScrollView(
            slivers: slivers,
          ),
        );
      },
    );
  }

  Widget _buildRankingsList(BuildContext context, int filterRankingTab,
          String label, List<Ranking> rankings) =>
      SliverList(
        delegate: SliverChildListDelegate(
            _buildRankings(context, filterRankingTab, label, rankings)),
      );

  List<Widget> _buildRankings(BuildContext context, int filterRankingTab,
      String label, List<Ranking> rankings) {
    List<Widget> slivers = [];
    int poleCounter = 1;

    slivers.add(Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: const Color.fromRGBO(153, 148, 86, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          ButtonBar(alignment: MainAxisAlignment.spaceAround, children: [
            // IconButton(
            //   color: filterRankingTab == 0 ? Theme.of(context).primaryColor :
            //   Colors.black,
            //   icon: Icon(FontAwesomeIcons.star), onPressed: () {
            //     BlocProvider.of<RankingBloc>(context)
            //     .add(ChangeRankingPodiumTabEvent(0));
            //    },
            // ),
            IconButton(
              color: filterRankingTab == 2 ? Colors.blue : Colors.black,
              icon: const Icon(FontAwesomeIcons.personRunning),
              onPressed: () {
                BlocProvider.of<RankingBloc>(context)
                    .add(ChangeRankingPodiumTabEvent(2));
              },
            ),
            IconButton(
              color: filterRankingTab == 3 ? Colors.blue : Colors.black,
              icon: const Icon(FontAwesomeIcons.bicycle),
              onPressed: () {
                BlocProvider.of<RankingBloc>(context)
                    .add(ChangeRankingPodiumTabEvent(3));
              },
            ),
            IconButton(
              color: filterRankingTab == 1 ? Colors.blue : Colors.black,
              icon: const Icon(FontAwesomeIcons.personWalking),
              onPressed: () {
                BlocProvider.of<RankingBloc>(context)
                    .add(ChangeRankingPodiumTabEvent(1));
              },
            ),
          ]),
        ],
      ),
    ));

    for (Ranking ranking in rankings) {
      double distance = 0;
      switch (ranking.mainActivity) {
        case ActivityType.run:
          distance = ( ranking.run ?? 0 ) / 1000;
          break;
        case ActivityType.walk:
          distance = ( ranking.walk ?? 0 ) / 1000;
          break;
        case ActivityType.ride:
          distance = ( ranking.ride ?? 0 ) / 1000;
          break;
      }
      Widget rankingPhoto = ranking.userPhoto.isEmpty
          ? Image.asset('assets/images/avatar.webp')
          : Image.network(ranking.userPhoto);
      IconData iconData;
      switch (ranking.mainActivity) {
        case ActivityType.ride:
          iconData = FontAwesomeIcons.bicycle;
          break;
        case ActivityType.walk:
          iconData = FontAwesomeIcons.personWalking;
          break;
        default:
          iconData = FontAwesomeIcons.personRunning;
      }

      if (filterRankingTab == 0) {
        iconData = FontAwesomeIcons.star;
      }

      slivers.add(
        Stack(
          children: [
            Positioned(
              child: Card(
                child: Stack(
                  children: [
                    ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: rankingPhoto),
                      title: Text(ranking.userFullname),
                      subtitle: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(iconData)),
                      trailing: Text(
                        '${distance.toStringAsFixed(1)} Km',
                        style: const TextStyle(fontSize: 19),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _poleImage(poleCounter),
          ],
        ),
      );

      poleCounter++;
    }

    return slivers;
  }

  Widget _poleImage(int poleCounter) {
    if (poleCounter <= 3) {
      return Positioned(
          left: 55.0,
          top: 27.0,
          width: 35,
          child: Image.asset('assets/images/medallas/medalla$poleCounter.png'));
    } else {
      return Positioned(
        left: 55.0,
        top: 37.0,
        width: 35,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            // height: 35,
            // width: 35,
            child: Text(
              '$poleCounter',
              style: const TextStyle(fontSize: 25.0),
            ),
          ),
          // child: Text(
          //   poleCounter.toString(),
          //   textAlign: TextAlign.center,
          //   style: TextStyle(backgroundColor: Colors.blue, fontSize: 25.0),
          // ),
        ),
      );
    }
  }
}
