import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';
import 'package:yodravet/src/bloc/state/race_state.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/race_spot.dart';
import 'package:yodravet/src/model/spot.dart';
import 'package:yodravet/src/page/race/widget/cartela.dart';
import 'package:yodravet/src/page/race/widget/spot_icon.dart';
import 'package:yodravet/src/widget/sliver_appbar_delegate.dart';

import '../../route/app_router_delegate.dart';
import 'race_basic_page.dart';
import 'widget/spot_page.dart';

class RaceDesktopPage extends RaceBasicPage {
  const RaceDesktopPage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    Artboard? riveArtboardSpain;
    Artboard? riveArtboardArgentina;
    bool loading = false;
    bool isSpainMapSelected = true;

    return BlocBuilder<RaceBloc, RaceState>(
        builder: (BuildContext context, state) {
      double kmCounter = 0;
      double stageCounter = 0;
      double extraCounter = 0;
      double stageLimit = 0;
      String? stageTitle = '';
      double? stageDayLeft = 0;
      List<Buyer> buyers = [];
      Spot? currentSpot;
      List<Spot>? spainStagesBuilding = [];
      List<Spot>? argentinaStagesBuilding = [];
      List<RaceSpot> raceSpots = [];
      List<String>? spotVotes;
      List<Widget> slivers = [];
      bool isRaceOver = false;
      bool canVote = false;
      bool hasVote = false;

      if (state is RaceInitState) {
        BlocProvider.of<RaceBloc>(context).add(InitRaceFieldsEvent());
        loading = true;
      } else if (state is UpdateRaceFieldsState) {
        kmCounter = state.kmCounter / 1000;
        stageCounter = state.stageCounter / 1000;
        extraCounter = state.extraCounter / 1000;
        stageLimit = state.stageLimit / 1000;
        stageTitle = state.stageTitle;
        riveArtboardSpain = state.riveArtboardSpain;
        riveArtboardArgentina = state.riveArtboardArgentina;
        buyers = state.buyers;
        spainStagesBuilding = state.spainStagesBuilding;
        argentinaStagesBuilding = state.argentinaStagesBuilding;
        raceSpots = state.raceSpots;
        spotVotes = state.spotVotes;
        currentSpot = state.currentSpot;
        loading = false;
        stageDayLeft = state.stageDayLeft;
        isRaceOver = state.isRaceOver;
        isSpainMapSelected = state.isSpainMapSelected;
        canVote = state.canVote;
        hasVote = state.hasVote;
        if (currentSpot != null) {
          BlocProvider.of<RaceBloc>(context).add(BackClickOnMapEvent());
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
                context: context,
                // shape: const RoundedRectangleBorder(
                //   borderRadius:
                //   BorderRadius.vertical(top: Radius.circular(25.0)),
                // ),
                builder: (BuildContext context) => SpotPage(
                    spot: currentSpot,
                    isVoted: spotVotes?.contains(currentSpot?.id) ?? false,
                    canVote: canVote,
                    hasVote: hasVote,
                    expandedHeight: MediaQuery.of(context).size.height - 300,
                    leadingWidth: MediaQuery.of(context).size.width,
                    imageFit: BoxFit.cover));
          });
        }
      } else if (state is RaceStateError) {
        loading = false;
      }

      if (loading) {
        return Container(
          alignment: Alignment.center,
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      slivers.clear();
      slivers.add(_buildCounters(context, kmCounter, stageTitle, stageLimit,
          stageCounter, extraCounter, stageDayLeft, isRaceOver));
      slivers.add(_buildMap(
          context,
          riveArtboardSpain,
          riveArtboardArgentina,
          buyers,
          spainStagesBuilding,
          argentinaStagesBuilding,
          raceSpots,
          isSpainMapSelected));

      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/race/logoYoCorroSinFondo.png"),
            // fit: BoxFit.fitHeight,
            scale: 1.0,
          ),
          // color: Color.fromRGBO(177, 237, 100, 93),
          color: Color.fromRGBO(153, 148, 86, 1),
        ),
        padding: const EdgeInsets.only(left: 30.0, right: 8.0),
        alignment: Alignment.center,
        child: CustomScrollView(
          slivers: slivers,
        ),
      );
    });
  }

  Widget _buildCounters(
          BuildContext context,
          double kmCounter,
          String stageTitle,
          double stageLimit,
          double stageCounter,
          double extraCounter,
          double stageDayLeft,
          bool isRaceOver) =>
      SliverPersistentHeader(
        pinned: false,
        delegate: SliverAppBarDelegate(
          minHeight: 180,
          maxHeight: 180,
          child: Row(
            mainAxisAlignment: isRaceOver
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !isRaceOver,
                child: Column(
                  children: [
                    Text(
                      stageTitle,
                      style: const TextStyle(
                        fontSize: 36,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.stageTitle,
                              style: const TextStyle(
                                fontSize: 26,
                              ),
                            ),
                            Row(
                              children: [
                                Countup(
                                  begin: 0,
                                  end: stageCounter,
                                  precision: 1,
                                  duration: const Duration(seconds: 3),
                                  // separator: '.',
                                  locale: Localizations.localeOf(context),
                                  style: const TextStyle(
                                    fontSize: 36,
                                  ),
                                ),
                                Text(
                                  ' / ${stageLimit.round()}',
                                  style: const TextStyle(fontSize: 36),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.leftDayTitle,
                              style: const TextStyle(
                                fontSize: 26,
                              ),
                            ),
                            Countup(
                              begin: 0,
                              end: stageDayLeft,
                              precision: 0,
                              duration: const Duration(seconds: 3),
                              // separator: '.',
                              locale: Localizations.localeOf(context),
                              style: const TextStyle(
                                fontSize: 36,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalTitle,
                    style: const TextStyle(fontSize: 46, color: Colors.red),
                  ),
                  Countup(
                    begin: 0,
                    end: kmCounter,
                    precision: 1,
                    duration: const Duration(seconds: 3),
                    // separator: '.',
                    locale: Localizations.localeOf(context),
                    style: const TextStyle(
                      fontSize: 56,
                      color: Colors.red,
                    ),
                  ),
                  Visibility(
                    visible: isRaceOver,
                    child: Text(
                      stageTitle,
                      style: const TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: !isRaceOver,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.extraTitle,
                      style: const TextStyle(
                        fontSize: 36,
                      ),
                    ),
                    Countup(
                      begin: 0,
                      end: extraCounter,
                      precision: 1,
                      duration: const Duration(seconds: 3),
                      // separator: '.',
                      locale: Localizations.localeOf(context),
                      style: const TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildMap(
      BuildContext context,
      Artboard? riveArtboardSpain,
      Artboard? riveArtboardArgentina,
      List<Buyer> buyers,
      List<Spot>? spainStagesBuilding,
      List<Spot>? argentinaStagesBuilding,
      List<RaceSpot> raceSpots,
      bool isSpainMapSelected) {
    Widget child;

    if (riveArtboardSpain != null && riveArtboardArgentina != null) {
      child = Row(
        children: [
          Expanded(
            flex: 2,
            child: Stack(children: [
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  height: 412,
                  width: 550,
                  child: Rive(
                    artboard: isSpainMapSelected
                        ? riveArtboardSpain
                        : riveArtboardArgentina,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              _countryLeftButton(context, isSpainMapSelected),
              _countryRightButton(context, isSpainMapSelected),
              isSpainMapSelected
                  ? _spainSpots(context, spainStagesBuilding, raceSpots)
                  : _argentinaSpots(
                      context, argentinaStagesBuilding, raceSpots),
            ]),
          ),
          const Expanded(
              child: Cartela(vertical: 132),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Column(
          //     children: [
          //       Expanded(
          //         flex: 1,
          //         child: Center(
          //           child: RichText(
          //             text: TextSpan(
          //                 text: AppLocalizations.of(context)!.buyLink,
          //                 style: const TextStyle(fontFamily: 'AkayaTelivigala'),
          //                 children: [
          //                   TextSpan(
          //                     text: 'Apoyo Dravet ',
          //                     style: const TextStyle(
          //                       fontSize: 16.0,
          //                       color: Colors.blue,
          //                       decoration: TextDecoration.underline,
          //                     ),
          //                     recognizer: TapGestureRecognizer()
          //                       ..onTap = () {
          //                         BlocProvider.of<RaceBloc>(context)
          //                             .add(PurchaseButterfliesEvent());
          //                       },
          //                   ),
          //                   const WidgetSpan(
          //                     child: Icon(FontAwesomeIcons.upRightFromSquare,
          //                         size: 11.0),
          //                   ),
          //                 ]),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 10,
          //         child: Scrollbar(
          //           child: ListView.builder(
          //               itemCount: buyers.length,
          //               itemBuilder: (context, index) =>
          //                   _buildBuyer(context, index, buyers[index])),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      );
    } else {
      child = Container();
    }

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
        minHeight: 370,
        maxHeight: 400,
        child: child,
      ),
    );
  }

  Widget _countryLeftButton(BuildContext context, bool isSpainMapSelected) =>
      Visibility(
        visible: isSpainMapSelected,
        child: Positioned(
          top: 190,
          left: 60,
          child: Column(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.circleArrowLeft),
                color: const Color.fromARGB(255, 140, 71, 153),
                iconSize: 30,
                onPressed: () => BlocProvider.of<RaceBloc>(context)
                    .add(ChangeMapSelectedEvent()),
              ),
              const Column(
                children: [
                  Text("Argentina"),
                  Text("Chile"),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _countryRightButton(BuildContext context, bool isSpainMapSelected) =>
      Visibility(
        visible: !isSpainMapSelected,
        child: Positioned(
          top: 190,
          left: 400,
          child: Column(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.circleArrowRight),
                color: const Color.fromARGB(255, 140, 71, 153),
                iconSize: 30,
                onPressed: () => BlocProvider.of<RaceBloc>(context)
                    .add(ChangeMapSelectedEvent()),
              ),
              const Text("España")
            ],
          ),
        ),
      );

  Stack _spainSpots(
      BuildContext context, List<Spot>? spots, List<RaceSpot> raceSpots) {
    int index = 0;
    List<Positioned> positionedList = spots?.map((element) {
          Spot spot = spots[index];
          index = index + 1;
          double top =
              MediaQuery.of(context).size.width >= 720 ? spot.top720 : spot.top;
          double left = MediaQuery.of(context).size.width >= 720
              ? spot.left720
              : spot.left;
          int vote = 0;
          try {
            vote =
                raceSpots.firstWhere((raceSpot) => raceSpot.id == spot.id).vote;
          } on StateError catch (_) {}
          return _buildSpot(top: top, left: left, spot: spot, vote: vote);
        }).toList() ??
        [];
    return Stack(
      children: positionedList,
    );
  }

  Stack _argentinaSpots(BuildContext context, List<Spot>? spots,
          List<RaceSpot> raceSpots) {
    int index = 0;
    List<Positioned> positionedList = spots?.map((element) {
      Spot spot = spots[index];
      index = index + 1;
      double top =
      MediaQuery.of(context).size.width >= 720 ? spot.top720 : spot.top;
      double left = MediaQuery.of(context).size.width >= 720
          ? spot.left720
          : spot.left;
      int vote = 0;
      try {
        vote =
            raceSpots.firstWhere((raceSpot) => raceSpot.id == spot.id).vote;
      } on StateError catch (_) {}
      return _buildSpot(top: top, left: left, spot: spot, vote: vote);
    }).toList() ??
        [];
    return Stack(
      children: positionedList,
    );
  }

  // Widget _buildBuyer(BuildContext context, int index, Buyer buyer) {
  //   int poleCounter = index + 1;
  //
  //   return ButterflyCard(buyer, poleCounter);
  // }
}

Positioned _buildSpot(
        {required double top,
        required double left,
        required Spot spot,
        required int vote}) =>
    Positioned(
      top: top,
      left: left,
      child: SpotIcon(
        spot.id,
        name: spot.shortName,
        photo: spot.photo,
        vote: vote,
      ),
    );
