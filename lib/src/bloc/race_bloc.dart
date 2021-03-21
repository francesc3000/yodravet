import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:bloc/bloc.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/stage_building.dart';
import 'package:yodravet/src/shared/race_map_factory.dart';

import 'event/race_event.dart';
import 'state/race_state.dart';

class RaceBloc extends Bloc<RaceEvent, RaceState> {
  Race _race = Race();
  final FactoryDao factoryDao;
  List<ActivityPurchase> _buyers = [];
  RaceMapFactory _raceMapFactory = RaceMapFactory();
  StageBuilding _currentStageBuilding;
  List<StageBuilding> _stagesBuilding = [
    StageBuilding(
      'Stage1',
      'C.I. Príncipe Felipe',
      'assets/race/centrofelipe.png',
      'blablabla',
    ),
    StageBuilding(
      'Stage2',
      'Universidad de Sevilla',
      'assets/race/vallhebron.png',
      'blablabla',
    ),
    StageBuilding(
      'Stage3',
      'Facultad Medicina Madrid',
      'assets/race/fmedicinamadrid.png',
      'blablabla',
    ),
  ];

  RaceBloc(this.factoryDao);

  @override
  RaceState get initialState => RaceInitState();

  @override
  Stream<RaceState> mapEventToState(RaceEvent event) async* {
    if (event is InitRaceFieldsEvent) {
      try {
        this
            .factoryDao
            .raceDao
            .streamRaceInfo('2021DravetTour')
            .listen((race) async {
          this._race.kmCounter = race.kmCounter;
          this._race.stageCounter = race.stageCounter;
          this._race.extraCounter = race.extraCounter;
          this._race.stage = race.stage;
          this._race.stageLimit = race.stageLimit;
          this._race.stageTitle = race.stageTitle;
          this._race.nextStageDate = race.nextStageDate;

          await _raceMapFactory.init(
              this._race.stage, this._race.nextStageDate);

          this.add(UpdateRaceFieldsEvent());
        });

        this.factoryDao.raceDao.streamBuyers('2021DravetTour').listen((buyers) {
          //Se consolidan los compradores
          this._buyers.clear();
          buyers.forEach((buyer) {
            var mainBuyerList = this._buyers.where(
                (mainBuyer) => mainBuyer.userId.compareTo(buyer.userId) == 0);

            if (mainBuyerList.isEmpty || mainBuyerList.first.userId.compareTo('anonymous')==0) {
              this._buyers.add(buyer);
            } else {
              var mainBuyer = mainBuyerList.first;
              mainBuyer.distance = mainBuyer.distance + buyer.distance;
              mainBuyer.totalPurchase =
                  mainBuyer.totalPurchase + buyer.totalPurchase;
            }
          });
          //Ordenamos por compra total
          this._buyers.sort((a, b) {
            return a.compareTo(b);
          });

          this.add(UpdateRaceFieldsEvent());
        });

        yield _updateRaceFieldsEvent();
      } catch (error) {
        yield error is RaceStateError
            ? RaceStateError(error.message)
            : RaceStateError('Algo fue mal al recoger los Km!');
      }
    } else if (event is UpdateRaceFieldsEvent) {
      yield _updateRaceFieldsEvent();
    } else if (event is ClickOnMapEvent) {
      try {
        _currentStageBuilding = _stagesBuilding.firstWhere((stageBuilding) => stageBuilding.id.compareTo(event.id)==0);
  
        yield _updateRaceFieldsEvent();
      } catch (error) {
        yield error is RaceStateError
            ? RaceStateError(error.message)
            : RaceStateError('Algo fue mal al clickar sobre el mapa');
      }
    }
  }

  RaceState _updateRaceFieldsEvent() {
    return UpdateRaceFieldsState(
      kmCounter: _race.kmCounter,
      stageCounter: _race.stageCounter,
      extraCounter: _race.extraCounter,
      stageLimit: _race.stageLimit,
      stageTitle: _race.stageTitle,
      riveArtboard: _raceMapFactory.riveArtboard,
      buyers: _buyers,
      currentStageBuilding: _currentStageBuilding,
      stagesBuilding: _stagesBuilding,
    );
  }
}
