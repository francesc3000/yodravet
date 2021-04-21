import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
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

class RaceDesktopPage extends RaceBasicPage {
  RaceDesktopPage(String title) : super(title);

  @override
  Widget body(BuildContext context) {
    Artboard _riveArtboard;
    bool _loading = false;
    bool _isShowModalOn = false;

    return BlocBuilder<RaceBloc, RaceState>(
        builder: (BuildContext context, state) {
      double _kmCounter = 0;
      double _stageCounter = 0;
      double _extraCounter = 0;
      double _stageLimit = 0;
      String _stageTitle = '';
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
        _riveArtboard = state.riveArtboard;
        _buyers = state.buyers;
        _stagesBuilding = state.stagesBuilding;
        _currentStageBuilding = state.currentStageBuilding;
        _loading = false;
        if (_currentStageBuilding != null && !_isShowModalOn) {
          _isShowModalOn = true;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Future future = showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (BuildContext context) {
                  return StageBuildingPage(
                    stageBuilding: _currentStageBuilding,
                    expandedHeight: MediaQuery.of(context).size.height - 300,
                    leadingWidth: MediaQuery.of(context).size.width,
                  );
                });
            future.then((_) =>
                BlocProvider.of<RaceBloc>(context).add(BackClickOnMapEvent()));
          });
        } else {
          _isShowModalOn = false;
        }
      } else if (state is RaceStateError) {
        _loading = false;
      }

      if (_loading)
        return Container(
          color: Color.fromRGBO(153, 148, 86, 60),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );

      slivers.clear();
      slivers.add(_buildCounters(context, _kmCounter, _stageTitle, _stageLimit,
          _stageCounter, _extraCounter));
      slivers.add(_buildMap(context, _riveArtboard, _buyers, _stagesBuilding));

      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/race/logoYoCorroSinFondo.png"),
            // fit: BoxFit.fitHeight,
            scale: 1.0,
          ),
          // color: Color.fromRGBO(177, 237, 100, 93),
          color: Color.fromRGBO(153, 148, 86, 60),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
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
      double extraCounter) {
    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
        minHeight: 140,
        maxHeight: 140,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  stageTitle,
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).stageTitle,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
                Row(
                  children: [
                    Countup(
                      begin: 0,
                      end: stageCounter,
                      precision: 2,
                      duration: Duration(seconds: 3),
                      separator: '.',
                      style: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      ' / ${stageLimit.round()}',
                      style: TextStyle(fontSize: 36),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  AppLocalizations.of(context).totalTitle,
                  style: TextStyle(fontSize: 46, color: Colors.red),
                ),
                Countup(
                  begin: 0,
                  end: kmCounter,
                  precision: 2,
                  duration: Duration(seconds: 3),
                  separator: '.',
                  style: TextStyle(
                    fontSize: 56,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  AppLocalizations.of(context).extraTitle,
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
                Countup(
                  begin: 0,
                  end: extraCounter,
                  precision: 2,
                  duration: Duration(seconds: 3),
                  separator: '.',
                  style: TextStyle(
                    fontSize: 36,
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
      List<ActivityPurchase> buyers, List<StageBuilding> stagesBuilding) {
    Widget child;

    if (riveArtboard != null) {
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
                    artboard: riveArtboard,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 190,
                left: 340,
                child: StageBuildingIcon(
                  stagesBuilding[0].id,
                  name: stagesBuilding[0].shortName,
                  photo: stagesBuilding[0].photo,
                ),
              ),
              Positioned(
                top: 310,
                left: 100,
                child: StageBuildingIcon(
                  stagesBuilding[1].id,
                  name: stagesBuilding[1].shortName,
                  photo: stagesBuilding[1].photo,
                ),
              ),
              Positioned(
                top: 160,
                left: 230,
                child: StageBuildingIcon(
                  stagesBuilding[2].id,
                  name: stagesBuilding[2].shortName,
                  photo: stagesBuilding[2].photo,
                ),
              ),
              Positioned(
                top: 130,
                left: 190,
                child: StageBuildingIcon(
                  stagesBuilding[3].id,
                  name: stagesBuilding[3].shortName,
                  photo: stagesBuilding[3].photo,
                ),
              ),
              Positioned(
                top: 17,
                // left: -4,
                child: StageBuildingIcon(
                  stagesBuilding[4].id,
                  name: stagesBuilding[4].shortName,
                  photo: stagesBuilding[4].photo,
                ),
              ),
              Positioned(
                top: 25,
                left: 215,
                child: StageBuildingIcon(
                  stagesBuilding[5].id,
                  name: stagesBuilding[5].shortName,
                  photo: stagesBuilding[5].photo,
                ),
              ),
              Positioned(
                top: 10,
                left: 180,
                child: StageBuildingIcon(
                  stagesBuilding[6].id,
                  name: stagesBuilding[6].shortName,
                  photo: stagesBuilding[6].photo,
                ),
              ),
              Positioned(
                top: 19,
                left: 278,
                child: StageBuildingIcon(
                  stagesBuilding[7].id,
                  name: stagesBuilding[7].shortName,
                  photo: stagesBuilding[7].photo,
                ),
              ),
              Positioned(
                top: 100,
                left: 440,
                child: StageBuildingIcon(
                  stagesBuilding[8].id,
                  name: stagesBuilding[8].shortName,
                  photo: stagesBuilding[8].photo,
                ),
              ),
              Positioned(
                top: 50,
                left: 440,
                child: StageBuildingIcon(
                  stagesBuilding[9].id,
                  name: stagesBuilding[9].shortName,
                  photo: stagesBuilding[9].photo,
                ),
              ),
              // Positioned(
              //   top: 90,
              //   left: 379,
              //   child: StageBuildingIcon(
              //     stagesBuilding[10].id,
              //     name: stagesBuilding[10].shortName,
              //     photo: stagesBuilding[10].photo,
              //   ),
              // ),
            ]),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Compra tus km en yodravet@gmail.com'),
                ),
                Expanded(
                  flex: 10,
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: buyers.length,
                        itemBuilder: (context, index) {
                          return _buildBuyer(context, index, buyers[index]);
                        }),
                  ),
                ),
              ],
            ),
          )
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

  Widget _buildBuyer(BuildContext context, int index, ActivityPurchase buyer) {
    double distance = buyer.distance / 1000;
    Widget userPhoto = buyer.userPhoto.isEmpty
        ? Image.asset('assets/defaultAvatar.png')
        : Image.network(
            buyer.userPhoto,
            loadingBuilder: (context, child, imageEvent) {
              return Image.asset('assets/defaultAvatar.png');
            },
          );
    int poleCounter = index + 1;

    return Stack(
      children: [
        Positioned(
          child: Card(
            color: Color.fromRGBO(89, 63, 153, 1),
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100), child: userPhoto),
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
            left: 45.0,
            top: 40.0,
            width: 35,
            child: Image.asset(
                'assets/medallas/medalla' + '$poleCounter' + '.png'),
          ),
        ),
      ],
    );
  }
}
