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

class RankingMobilePage extends RankingBasicPage {
  const RankingMobilePage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    List<Widget> slivers = [];
    bool loading = false;
    int filterRankingTab = 2;
    List<Ranking> rankings = [];
    List<Ranking> rankingsTeam = [];

    return BlocBuilder<RankingBloc, RankingState>(
      builder: (BuildContext context, state) {
        if (state is RankingInitState) {
          BlocProvider.of<RankingBloc>(context).add(LoadInitialDataEvent());
          loading = true;
        } else if (state is UploadRankingFieldsState) {
          filterRankingTab = state.filterRankingTab;
          rankings = state.rankings ?? [];
          rankingsTeam = state.rankingsTeam ?? [];
          loading = false;
        } else if (state is RankingStateError) {
          //TODO: Mostrar errores en Pages
          // CustomSnackBar
        }

        if (loading) {
          return Container(
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: const Center(child: CircularProgressIndicator()));
        }

        slivers.clear();
        slivers.add(_buildRankingsList(context, filterRankingTab,
            AppLocalizations.of(context)!.rankingDonerKm, rankings));
        slivers.add(_buildRankingsList(context, filterRankingTab,
            AppLocalizations.of(context)!.rankingDonerTeamKm, rankingsTeam));

        return Container(
          color: const Color.fromRGBO(153, 148, 86, 1),
          padding: const EdgeInsets.only(bottom: 30.0),
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
              _buildRankings(context, filterRankingTab, label, rankings)));

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
          left: 58.0,
          top: 33.0,
          width: 35,
          child: Image.asset('assets/images/medallas/medalla$poleCounter.png'));
    } else {
      return Positioned(
        left: 58.0,
        top: 40.0,
        width: 40,
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

  // Widget _getRankings(BuildContext context, String churro) =>
  //     SliverPersistentHeader(
  //       pinned: true,
  //       delegate: SliverAppBarDelegate(
  //         minHeight: 140,
  //         maxHeight: 240,
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: SelectableText.rich(
  //             TextSpan(
  //               text: churro,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
}
