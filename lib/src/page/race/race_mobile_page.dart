import 'package:countup/countup.dart';
import 'package:flutter/gestures.dart';
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
import 'package:yodravet/src/page/race/widget/butterfly_card.dart';
import 'package:yodravet/src/page/race/widget/cartela.dart';
import 'package:yodravet/src/page/race/widget/spot_icon.dart';
import 'package:yodravet/src/widget/sliver_appbar_delegate.dart';

import '../../route/app_router_delegate.dart';
import 'race_basic_page.dart';
import 'widget/spot_page.dart';

class RaceMobilePage extends RaceBasicPage {
  const RaceMobilePage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key, bool isPortrait = true})
      : super(title, appRouterDelegate, isPortrait: isPortrait, key: key);

  @override
  Widget body(BuildContext context) {
    Artboard? _riveArtboardSpain;
    Artboard? _riveArtboardArgentina;
    bool _loading = false;
    bool _isSpainMapSelected = true;

    return BlocBuilder<RaceBloc, RaceState>(
        builder: (BuildContext context, state) {
      double _kmCounter = 0;
      double _stageCounter = 0;
      double _extraCounter = 0;
      double _stageLimit = 0;
      String? _stageTitle = '';
      double? _stageDayLeft = 0;
      List<Buyer> _buyers = [];
      Spot? _currentSpot;
      List<Spot>? _spainStagesBuilding = [];
      List<Spot>? _argentinaStagesBuilding = [];
      List<RaceSpot> _raceSpots = [];
      List<String>? _spotVotes = [];
      List<Widget> slivers = [];
      bool _isRaceOver = false;
      bool _canVote = false;
      bool _hasVote = false;

      if (state is RaceInitState) {
        BlocProvider.of<RaceBloc>(context).add(InitRaceFieldsEvent());
        _loading = true;
      } else if (state is UpdateRaceFieldsState) {
        _kmCounter = state.kmCounter / 1000;
        _stageCounter = state.stageCounter / 1000;
        _extraCounter = state.extraCounter / 1000;
        _stageLimit = state.stageLimit / 1000;
        _stageTitle = state.stageTitle;
        _stageDayLeft = state.stageDayLeft;
        _riveArtboardSpain = state.riveArtboardSpain;
        _riveArtboardArgentina = state.riveArtboardArgentina;
        _buyers = state.buyers;
        _spainStagesBuilding = state.spainStagesBuilding;
        _argentinaStagesBuilding = state.argentinaStagesBuilding;
        _raceSpots = state.raceSpots;
        _spotVotes = state.spotVotes;
        _currentSpot = state.currentSpot;
        _isSpainMapSelected = state.isSpainMapSelected;
        _isRaceOver = state.isRaceOver;
        _canVote = state.canVote;
        _hasVote = state.hasVote;
        _loading = false;
        if (_currentSpot != null) {
          BlocProvider.of<RaceBloc>(context).add(BackClickOnMapEvent());
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (BuildContext context) => SpotPage(
                    spot: _currentSpot,
                    isVoted: _spotVotes?.contains(_currentSpot?.id) ?? false,
                    canVote: _canVote,
                    hasVote: _hasVote,
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    leadingWidth: MediaQuery.of(context).size.width,
                    imageFit: BoxFit.cover));
          });
        }
      } else if (state is RaceStateError) {
        _loading = false;
      }

      if (_loading) {
        return Container(
          color: const Color.fromRGBO(153, 148, 86, 1),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      }

      slivers.clear();
      slivers.add(_buildTotalCounter(context, _kmCounter));
      slivers.add(_buildSubCounters(context, _stageTitle, _stageLimit,
          _stageCounter, _extraCounter, _stageDayLeft, _isRaceOver));
      slivers.add(_buildMap(
          context,
          _riveArtboardSpain,
          _riveArtboardArgentina,
          _spainStagesBuilding,
          _argentinaStagesBuilding,
          _raceSpots,
          _isSpainMapSelected));
      // slivers.add(_buildBuyersList(context, _buyers));
      slivers.add(_buildCartela(context));

      return Container(
        color: const Color.fromRGBO(153, 148, 86, 1),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        alignment: Alignment.center,
        child: CustomScrollView(
          slivers: slivers,
        ),
      );
    });
  }

  Widget _buildTotalCounter(BuildContext context, double kmCounter) =>
      SliverPersistentHeader(
        pinned: false,
        delegate: SliverAppBarDelegate(
          minHeight: 100,
          maxHeight: 100,
          child: Container(
            alignment: Alignment.center,
            // color: Colors.white,
            // color: Color.fromRGBO(153, 148, 86, 60 ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.totalTitle,
                  style: const TextStyle(fontSize: 26),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSubCounters(
          BuildContext context,
          String stageTitle,
          double stageLimit,
          double stageCounter,
          double extraCounter,
          double stageDayLeft,
          bool isRaceOver) =>
      SliverPersistentHeader(
        pinned: false,
        delegate: SliverAppBarDelegate(
          minHeight: 80,
          maxHeight: 80,
          child: Row(
            mainAxisAlignment: !isRaceOver
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(stageTitle),
                  Visibility(
                    visible: !isRaceOver,
                    child: Text(AppLocalizations.of(context)!.stageTitle),
                  ),
                  Visibility(
                    visible: !isRaceOver,
                    child: Row(
                      children: [
                        Countup(
                          begin: 0,
                          end: stageCounter,
                          precision: 1,
                          duration: const Duration(seconds: 3),
                          // separator: '.',
                          locale: Localizations.localeOf(context),
                          style: const TextStyle(
                            fontSize: 26,
                          ),
                        ),
                        Text(
                          ' / ${stageLimit.round()}',
                          style: const TextStyle(fontSize: 26),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: !isRaceOver,
                child: const Spacer(),
              ),
              Visibility(
                visible: !isRaceOver,
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.leftDayTitle),
                    Countup(
                      begin: 0,
                      end: stageDayLeft,
                      precision: 0,
                      duration: const Duration(seconds: 3),
                      // separator: '.',
                      locale: Localizations.localeOf(context),
                      style: const TextStyle(
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(visible: !isRaceOver, child: const Spacer()),
              Visibility(
                visible: !isRaceOver,
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.extraTitle),
                    Countup(
                      begin: 0,
                      end: extraCounter,
                      precision: 1,
                      duration: const Duration(seconds: 3),
                      // separator: '.',
                      locale: Localizations.localeOf(context),
                      style: const TextStyle(
                        fontSize: 26,
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
      List<Spot>? spainStagesBuilding,
      List<Spot>? argentinaStagesBuilding,
      List<RaceSpot> raceSpots,
      bool isSpainMapSelected) {
    Widget child;
    // double mapWidth = isPortrait ? MediaQuery.of(context).size.width - 10 : 380;
    double mapWidth = isPortrait ? MediaQuery.of(context).size.width - 10 : 380;
    double mapHeight = 380;

    if (riveArtboardSpain != null && riveArtboardArgentina != null) {
      child = Stack(children: [
        Positioned(
          top: 0,
          // left: 0,
          child: SizedBox(
            height: mapHeight,
            width: mapWidth,
            child: Rive(
              artboard: isSpainMapSelected
                  ? riveArtboardSpain
                  : riveArtboardArgentina,
              fit: BoxFit.contain,
            ),
          ),
        ),
        _countryLeftButton(context, isSpainMapSelected, mapHeight, mapWidth),
        _countryRightButton(context, isSpainMapSelected, mapHeight, mapWidth),
        isSpainMapSelected
            ? _spainSpots(
                context, mapHeight, mapWidth, spainStagesBuilding, raceSpots)
            : _argentinaSpots(context, mapHeight, mapWidth,
                argentinaStagesBuilding, raceSpots),
      ]);
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

  Widget _countryLeftButton(BuildContext context, bool isSpainMapSelected,
          double mapHeight, double mapWidth) =>
      Visibility(
        visible: isSpainMapSelected,
        child: Positioned(
          top: mapHeight * 0.47,
          left: mapWidth * 0.0001,
          child: Column(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.circleArrowLeft),
                color: const Color.fromARGB(255, 140, 71, 153),
                iconSize: 30,
                onPressed: () => BlocProvider.of<RaceBloc>(context)
                    .add(ChangeMapSelectedEvent()),
              ),
              Column(
                children: const [
                  Text("Argentina"),
                  Text("Chile"),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _countryRightButton(BuildContext context, bool isSpainMapSelected,
          double mapHeight, double mapWidth) =>
      Visibility(
        visible: !isSpainMapSelected,
        child: Positioned(
          top: mapHeight * 0.47,
          left: mapWidth * 0.83,
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

  Stack _spainSpots(BuildContext context, double mapHeight, double mapWidth,
      List<Spot>? spots, List<RaceSpot> raceSpots) {
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
          return _buildSpot(
              top: mapHeight * top,
              left: mapWidth * left,
              spot: spot,
              vote: vote);
        }).toList() ??
        [];
    return Stack(
      children: positionedList,
    );
  }
}

Stack _argentinaSpots(BuildContext context, double mapHeight, double mapWidth,
    List<Spot>? spots, List<RaceSpot> raceSpots) {
  int index = 0;
  List<Positioned> positionedList = spots?.map((element) {
        Spot spot = spots[index];
        index = index + 1;
        double top =
            MediaQuery.of(context).size.width >= 720 ? spot.top720 : spot.top;
        double left =
            MediaQuery.of(context).size.width >= 720 ? spot.left720 : spot.left;
        int vote = 0;
        try {
          vote =
              raceSpots.firstWhere((raceSpot) => raceSpot.id == spot.id).vote;
        } on StateError catch (_) {}
        return _buildSpot(
            top: mapHeight * top,
            left: mapWidth * left,
            spot: spot,
            vote: vote);
      }).toList() ??
      [];
  return Stack(
    children: positionedList,
  );
}

Widget _buildBuyersList(BuildContext context, List<Buyer> buyers) => SliverList(
      delegate: SliverChildListDelegate(_buildBuyers(context, buyers)),
    );

List<Widget> _buildBuyers(BuildContext context, List<Buyer> buyers) {
  List<Widget> slivers = [];
  int poleCounter = 1;

  slivers.add(
    Center(
      child: RichText(
        text: TextSpan(
            text: AppLocalizations.of(context)!.buyLink,
            style: const TextStyle(fontFamily: 'AkayaTelivigala'),
            children: [
              TextSpan(
                text: 'Apoyo Dravet ',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    BlocProvider.of<RaceBloc>(context)
                        .add(PurchaseButterfliesEvent());
                  },
              ),
              const WidgetSpan(
                child: Icon(FontAwesomeIcons.upRightFromSquare, size: 11.0),
              ),
            ]),
      ),
    ),
  );

  // for (Buyer buyer in buyers) {
  //   slivers.add(ButterflyCard(buyer, poleCounter));
  //   poleCounter++;
  // }

  return slivers;
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

Widget _buildCartela(BuildContext context) => SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
        minHeight: 120,
        maxHeight: 120,
        child: Cartela(vertical: 12),
      ),
    );
