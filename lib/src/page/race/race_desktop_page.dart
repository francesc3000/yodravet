import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';
import 'package:yodravet/src/bloc/state/race_state.dart';
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
                    expandedHeight: MediaQuery.of(context).size.height - 300,
                    leadingWidth: MediaQuery.of(context).size.width,
                  );
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
      slivers.add(_buildCounters(context, _kmCounter, _stageTitle, _stageLimit,
          _stageCounter, _extraCounter));
      slivers.add(_buildMap(context, _riveArtboard, _buyers, _stagesBuilding));

      return Container(
        // color: Color.fromRGBO(177, 237, 100, 93),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/race/logoYoCorro.png"),
            fit: BoxFit.fitHeight,
          ),
          color: Color.fromRGBO(177, 237, 100, 93),
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
        minHeight: 100,
        maxHeight: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(stageTitle),
                Text('Km Etapa:'),
                Row(
                  children: [
                    Countup(
                      begin: 0,
                      end: stageCounter,
                      precision: 2,
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
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Km Totales:',
                    style: TextStyle(fontSize: 26),
                  ),
                  Countup(
                    begin: 0,
                    end: kmCounter,
                    precision: 2,
                    duration: Duration(seconds: 3),
                    separator: '.',
                    style: TextStyle(
                      fontSize: 56,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text('Km Acumulado:'),
                Countup(
                  begin: 0,
                  end: extraCounter,
                  precision: 2,
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
                top: 180,
                left: 361,
                child: StageBuildingIcon(
                  stagesBuilding[0].id,
                  name: stagesBuilding[0].name,
                  photo: stagesBuilding[0].photo,
                ),
              ),
              Positioned(
                top: 300,
                left: 81,
                child: StageBuildingIcon(
                  stagesBuilding[1].id,
                  name: stagesBuilding[1].name,
                  photo: stagesBuilding[1].photo,
                ),
              ),
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
