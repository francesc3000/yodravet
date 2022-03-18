import 'package:countup/countup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';
import 'package:yodravet/src/bloc/state/race_state.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/stage_building.dart';
import 'package:yodravet/src/page/race/widget/butterfly_card.dart';
import 'package:yodravet/src/page/race/widget/stage_building_icon.dart';
import 'package:yodravet/src/widget/sliver_appbar_delegate.dart';

import '../../route/app_router_delegate.dart';
import 'race_basic_page.dart';
import 'widget/stage_building_page.dart';

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
      StageBuilding? _currentStageBuilding;
      List<StageBuilding>? _spainStagesBuilding = [];
      List<StageBuilding>? _argentinaStagesBuilding = [];
      List<Widget> slivers = [];
      bool _isRaceOver = false;

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
        _currentStageBuilding = state.currentStageBuilding;
        _isSpainMapSelected = state.isSpainMapSelected;
        _isRaceOver = state.isRaceOver;
        _loading = false;
        if (_currentStageBuilding != null) {
          BlocProvider.of<RaceBloc>(context).add(BackClickOnMapEvent());
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (BuildContext context) => StageBuildingPage(
                    stageBuilding: _currentStageBuilding,
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    leadingWidth: MediaQuery.of(context).size.width,
                    imageFit: BoxFit.cover));
          });
        }
      } else if (state is RaceStateError) {
        _loading = false;
      }

      if (_loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      slivers.clear();
      slivers.add(_buildTotalCounter(context, _kmCounter));
      slivers.add(_buildSubCounters(context, _stageTitle, _stageLimit,
          _stageCounter, _extraCounter, _stageDayLeft, _isRaceOver));
      slivers.add(_buildMap(context, _riveArtboardSpain, _riveArtboardArgentina,
          _spainStagesBuilding, _argentinaStagesBuilding, _isSpainMapSelected));
      slivers.add(_buildBuyersList(context, _buyers));

      return Container(
        color: const Color.fromRGBO(153, 148, 86, 60),
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
            mainAxisAlignment: isRaceOver
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(stageTitle),
                  Visibility(
                    visible: isRaceOver,
                    child: Text(AppLocalizations.of(context)!.stageTitle),
                  ),
                  Visibility(
                    visible: isRaceOver,
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
                visible: isRaceOver,
                child: const Spacer(),
              ),
              Visibility(
                visible: isRaceOver,
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
              Visibility(visible: isRaceOver, child: const Spacer()),
              Visibility(
                visible: isRaceOver,
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
      List<StageBuilding>? spainStagesBuilding,
      List<StageBuilding>? argentinaStagesBuilding,
      bool isSpainMapSelected) {
    Widget child;
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
            ? _spainSpots(context, mapHeight, mapWidth, spainStagesBuilding)
            : _argentinaSpots(
                context, mapHeight, mapWidth, argentinaStagesBuilding),
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
                icon: const Icon(FontAwesomeIcons.arrowCircleLeft),
                color: const Color.fromARGB(255, 140, 71, 153),
                iconSize: 30,
                onPressed: () => BlocProvider.of<RaceBloc>(context)
                    .add(ChangeMapSelectedEvent()),
              ),
              const Text("Argentina")
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
                icon: const Icon(FontAwesomeIcons.arrowCircleRight),
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
          List<StageBuilding>? stagesBuilding) =>
      Stack(
        children: [
          Positioned(
            top: mapHeight * 0.47,
            left: mapWidth * 0.57,
            child: StageBuildingIcon(
              stagesBuilding![0].id,
              name: stagesBuilding[0].shortName,
              photo: stagesBuilding[0].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.74,
            left: mapWidth * 0.12,
            child: StageBuildingIcon(
              stagesBuilding[1].id,
              name: stagesBuilding[1].shortName,
              photo: stagesBuilding[1].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.41,
            left: mapWidth * 0.37,
            child: StageBuildingIcon(
              stagesBuilding[2].id,
              name: stagesBuilding[2].shortName,
              photo: stagesBuilding[2].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.34,
            left: mapWidth * 0.27,
            child: StageBuildingIcon(
              stagesBuilding[3].id,
              name: stagesBuilding[3].shortName,
              photo: stagesBuilding[3].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.24,
            left: mapWidth * 0.38,
            child: StageBuildingIcon(
              stagesBuilding[4].id,
              name: stagesBuilding[4].shortName,
              photo: stagesBuilding[4].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.06,
            // left: -4,
            child: StageBuildingIcon(
              stagesBuilding[5].id,
              name: stagesBuilding[5].shortName,
              photo: stagesBuilding[5].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.03,
            left: mapWidth * 0.24,
            child: StageBuildingIcon(
              stagesBuilding[6].id,
              name: stagesBuilding[6].shortName,
              photo: stagesBuilding[6].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.08,
            left: mapWidth * 0.38,
            child: StageBuildingIcon(
              stagesBuilding[7].id,
              name: stagesBuilding[7].shortName,
              photo: stagesBuilding[7].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.07,
            left: mapWidth * 0.51,
            child: StageBuildingIcon(
              stagesBuilding[8].id,
              name: stagesBuilding[8].shortName,
              photo: stagesBuilding[8].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.29,
            left: mapWidth * 0.74,
            child: StageBuildingIcon(
              stagesBuilding[9].id,
              name: stagesBuilding[9].shortName,
              photo: stagesBuilding[9].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.12,
            left: mapWidth * 0.76,
            child: StageBuildingIcon(
              stagesBuilding[10].id,
              name: stagesBuilding[10].shortName,
              photo: stagesBuilding[10].photo,
            ),
          ),
          Positioned(
            top: mapHeight * 0.25,
            left: mapWidth * 0.6,
            child: StageBuildingIcon(
              stagesBuilding[11].id,
              name: stagesBuilding[11].shortName,
              photo: stagesBuilding[11].photo,
            ),
          ),
        ],
      );

  Stack _argentinaSpots(BuildContext context, double mapHeight, double mapWidth,
          List<StageBuilding>? stagesBuilding) =>
      Stack(
        children: [
          Positioned(
            top: mapHeight * 0.26,
            left: mapWidth * 0.32,
            child: StageBuildingIcon(
              stagesBuilding![0].id,
              name: stagesBuilding[0].shortName,
              photo: stagesBuilding[0].photo,
            ),
          ),
        ],
      );

  Widget _buildBuyersList(BuildContext context, List<Buyer> buyers) =>
      SliverList(
        delegate: SliverChildListDelegate(_buildBuyers(context, buyers)),
      );

  List<Widget> _buildBuyers(BuildContext context, List<Buyer> buyers) {
    List<Widget> slivers = [];
    int poleCounter = 1;

    slivers.add(
      Center(
        child: RichText(
          text: TextSpan(
              text: 'Compra tus mariposas en ',
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
                      launch(
                          'https://www.apoyodravet.eu/tienda-solidaria/'
                              'donacion/compra-kilometros-solidarios-dravet'
                              '-tour?utm_source=app&utm_medium='
                              'enlace&utm_campaign=compra-'
                              'kilometros-dravet-tour');
                    },
                ),
                const WidgetSpan(
                  child: Icon(FontAwesomeIcons.externalLinkAlt, size: 11.0),
                ),
              ]),
        ),
      ),
    );

    for (Buyer buyer in buyers) {
      slivers.add(ButterflyCard(buyer, poleCounter));
      poleCounter++;
    }

    return slivers;
  }
}
