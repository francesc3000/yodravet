import 'package:countup/countup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';
import 'package:yodravet/src/bloc/state/race_state.dart';
import 'package:yodravet/src/locale/locales.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/stage_building.dart';
import 'package:yodravet/src/page/race/widget/stage_building_icon.dart';
import 'package:yodravet/src/widget/sliver_appbar_delegate.dart';

import 'race_basic_page.dart';
import 'widget/stage_building_page.dart';

class RaceMobilePage extends RaceBasicPage {
  RaceMobilePage(String title, {bool isPortrait: true})
      : super(title, isPortrait: isPortrait);

  @override
  Widget body(BuildContext context) {
    Artboard _riveArtboard;
    bool _loading = false;

    return BlocBuilder<RaceBloc, RaceState>(
        builder: (BuildContext context, state) {
      double _kmCounter = 0;
      double _stageCounter = 0;
      double _extraCounter = 0;
      double _stageLimit = 0;
      String _stageTitle = '';
      double _stageDayLeft = 0;
      List<ActivityPurchase> _buyers = [];
      StageBuilding _currentStageBuilding;
      List<StageBuilding> _stagesBuilding = [];
      List<Widget> slivers = [];

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
        _riveArtboard = state.riveArtboard;
        _buyers = state.buyers;
        _stagesBuilding = state.stagesBuilding;
        _currentStageBuilding = state.currentStageBuilding;
        _loading = false;
        if (_currentStageBuilding != null) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (BuildContext context) {
                  return StageBuildingPage(
                      stageBuilding: _currentStageBuilding,
                      expandedHeight: MediaQuery.of(context).size.height / 3,
                      leadingWidth: MediaQuery.of(context).size.width,
                      imageFit: BoxFit.cover);
                });
          });
        }
      } else if (state is RaceStateError) {
        _loading = false;
      }

      if (_loading)
        return Center(
          child: CircularProgressIndicator(),
        );

      slivers.clear();
      slivers.add(_buildTotalCounter(context, _kmCounter));
      slivers.add(_buildSubCounters(
          context, _stageTitle, _stageLimit, _stageCounter, _extraCounter, _stageDayLeft));
      slivers.add(_buildMap(context, _riveArtboard, _stagesBuilding));
      slivers.add(_buildBuyersList(context, _buyers));

      return Container(
        color: Color.fromRGBO(153, 148, 86, 60),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        alignment: Alignment.center,
        child: CustomScrollView(
          slivers: slivers,
        ),
      );
    });
  }

  Widget _buildTotalCounter(BuildContext context, double kmCounter) {
    return SliverPersistentHeader(
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
                AppLocalizations.of(context).totalTitle,
                style: TextStyle(fontSize: 26),
              ),
              Countup(
                begin: 0,
                end: kmCounter,
                precision: 1,
                duration: Duration(seconds: 3),
                separator: '.',
                style: TextStyle(
                  fontSize: 56,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubCounters(BuildContext context, String stageTitle,
      double stageLimit, double stageCounter, double extraCounter, double stageDayLeft) {
    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
        minHeight: 80,
        maxHeight: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(stageTitle),
                Text(AppLocalizations.of(context).stageTitle),
                Row(
                  children: [
                    Countup(
                      begin: 0,
                      end: stageCounter,
                      precision: 1,
                      duration: Duration(seconds: 3),
                      separator: '.',
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    Text(
                      ' / ${stageLimit.round()}',
                      style: TextStyle(fontSize: 26),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text(AppLocalizations.of(context).leftDayTitle),
                Countup(
                  begin: 0,
                  end: stageDayLeft,
                  precision: 0,
                  duration: Duration(seconds: 3),
                  separator: '.',
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text(AppLocalizations.of(context).extraTitle),
                Countup(
                  begin: 0,
                  end: extraCounter,
                  precision: 1,
                  duration: Duration(seconds: 3),
                  separator: '.',
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context, Artboard riveArtboard,
      List<StageBuilding> stagesBuilding) {
    Widget child;
    double mapWidth =
        this.isPortrait ? MediaQuery.of(context).size.width - 10 : 380;
    double mapHeight = 380;

    if (riveArtboard != null) {
      child = Stack(children: [
        Positioned(
          top: 0,
          // left: 0,
          child: SizedBox(
            height: mapHeight,
            width: mapWidth,
            child: Rive(
              artboard: riveArtboard,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: mapHeight * 0.47,
          left: mapWidth * 0.57,
          child: StageBuildingIcon(
            stagesBuilding[0].id,
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

  Widget _buildBuyersList(BuildContext context, List<ActivityPurchase> buyers) {
    return SliverList(
      delegate: SliverChildListDelegate(_buildBuyers(context, buyers)),
    );
  }

  List<Widget> _buildBuyers(
      BuildContext context, List<ActivityPurchase> buyers) {
    List<Widget> slivers = [];
    int poleCounter = 1;

    // if (buyers.isNotEmpty) {
    // slivers.add(Center(child: Text('Compra tus km en yodravetapp@gmail.com')));
    // }

    slivers.add(
      Center(
        child: RichText(
          text: TextSpan(
              text: 'Compra tus km solidarios en ',
              style: TextStyle(fontFamily: 'AkayaTelivigala'),
              children: [
                TextSpan(
                  text: 'Apoyo Dravet ',
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                    fontFamily: 'AkayaTelivigala',
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      launch(
                          'https://www.apoyodravet.eu/tienda-solidaria/donacion/compra-kilometros-solidarios-dravet-tour?utm_source=app&utm_medium=enlace&utm_campaign=compra-kilometros-dravet-tour');
                    },
                ),
                WidgetSpan(
                  child: Icon(FontAwesomeIcons.externalLinkAlt, size: 11.0),
                ),
              ]),
        ),
      ),
    );

    for (ActivityPurchase buyer in buyers) {
      double distance = buyer.distance / 1000;
      Widget userPhoto = buyer.userPhoto.isEmpty
          ? Image.asset('assets/defaultAvatar.png')
          : Image.network(
              buyer.userPhoto,
              loadingBuilder: (context, child, imageEvent) {
                return Image.asset('assets/defaultAvatar.png');
              },
            );

      slivers.add(
        Stack(
          children: [
            Positioned(
              child: Card(
                color: Color.fromRGBO(89, 63, 153, 1),
                child: ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: userPhoto),
                  title: Text('${buyer.userFullname}'),
                  subtitle: Text('${buyer.totalPurchase}' + ' €'),
                  trailing: Text(
                    '${distance.toString()}' + 'Km',
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: poleCounter > 3 ? false : true,
              child: Positioned(
                left: 55.0,
                top: 40.0,
                width: 35,
                child: Image.asset(
                    'assets/medallas/medalla' + '$poleCounter' + '.png'),
              ),
            ),
          ],
        ),
      );

      poleCounter++;
    }

    return slivers;
  }
}
