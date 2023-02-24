import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/ranking.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/shared/edition.dart';

import 'event/ranking_event.dart';
import 'session_bloc.dart';
import 'state/ranking_state.dart';
import 'state/session_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  final FactoryDao factoryDao;
  final SessionBloc session;
  StreamSubscription? _sessionSubscription;
  StreamSubscription? _rankingSubscription;
  User? _user;
  List<Ranking> _rankings = [];
  List<Ranking> _filterRankings = [];
  List<Ranking> _filterRankingsTeam = [];
  int _filterRankingTab = 2;

  RankingBloc(this.session, this.factoryDao) : super(RankingInitState()) {
    _sessionSubscription = session.stream.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          _user = session.user;
        }
      } else if (state is LogOutState) {
        _user = null;
      } else if (state is UserChangeState) {
        _user = session.user;
      }
    });

    _user = session.user;

    on<LoadInitialDataEvent>(_loadInitialDataEvent);
    on<ChangeRankingPodiumTabEvent>(_changeRankingPodiumTabEvent);
    on<UploadRankingFieldsEvent>(_uploadRankingFieldsEvent);
  }

  void _loadInitialDataEvent(LoadInitialDataEvent event, Emitter emit) async {
    String currentEdition = Edition.currentEdition;
    try {
      _rankingSubscription =
          factoryDao.raceDao.streamRanking(currentEdition).listen((rankings) {
        _rankings = rankings;

        add(ChangeRankingPodiumTabEvent(_filterRankingTab));
      });
    } catch (error) {
      emit(error is RankingStateError
          ? RankingStateError(error.message)
          : RankingStateError(
              'Algo fue mal al cargar los datos iniciales del usuario!'));
    }
  }

  void _changeRankingPodiumTabEvent(
      ChangeRankingPodiumTabEvent event, Emitter emit) async {
    try {
      _filterRankings = [];
      _filterRankingsTeam = [];
      _filterRankingTab = event.indexTab;

      for (var ranking in _rankings) {
        bool _insert = false;
        switch (_filterRankingTab) {
          case 1:
            ranking.setMainActivity(ActivityType.walk);
            if (ranking.walk != null) {
              _insert = true;
            }
            break;
          case 2:
            ranking.setMainActivity(ActivityType.run);
            if (ranking.run != null) {
              _insert = true;
            }
            break;
          case 3:
            ranking.setMainActivity(ActivityType.ride);
            if (ranking.ride != null) {
              _insert = true;
            }
            break;
        }

        if (_insert) {
          if (ranking.isTeam) {
            _filterRankingsTeam.add(ranking);
          } else {
            _filterRankings.add(ranking);
          }
        }
      }

      // switch (_filterRankingTab) {
      //   case 1:
      //     _filterRankings.removeWhere((ranking) =>
      //         ranking.type != ActivityType.walk || ranking.isTeam == true);
      //     _filterRankingsTeam.removeWhere((ranking) =>
      //     ranking.type != ActivityType.walk || ranking.isTeam == false);
      //     break;
      //   case 2:
      //     _filterRankings.removeWhere((ranking) =>
      //         ranking.type != ActivityType.run || ranking.isTeam == true);
      //     _filterRankingsTeam.removeWhere((ranking) =>
      //     ranking.type != ActivityType.run || ranking.isTeam == false);
      //     break;
      //   case 3:
      //     _filterRankings.removeWhere((ranking) =>
      //         ranking.type != ActivityType.ride || ranking.isTeam == true);
      //     _filterRankingsTeam.removeWhere((ranking) =>
      //     ranking.type != ActivityType.ride || ranking.isTeam == false);
      //     break;
      //   default:
      // }

      //Ordenamos por km recorridos
      _filterRankings.sort((a, b) => a.compareTo(b));
      _filterRankingsTeam.sort((a, b) => a.compareTo(b));

      // _filterRankings = _consolidateAndSortRankings(_filterRankings);
      emit(_uploadRankingFields());
    } catch (error) {
      emit(error is RankingStateError
          ? RankingStateError(error.message)
          : RankingStateError('Algo fue mal al cambiar de pestaña!'));
    }
  }

  void _uploadRankingFieldsEvent(
      UploadRankingFieldsEvent event, Emitter emit) async {
    emit(_uploadRankingFields());
  }

  RankingState _uploadRankingFields() => UploadRankingFieldsState(
      _filterRankingTab, _filterRankings, _filterRankingsTeam);

  List<ActivityPurchase> _consolidateAndSortRankings(
      List<ActivityPurchase> rankings) {
    List<ActivityPurchase> rankingsAux = [];
    List<ActivityPurchase> rankingsReturn = [];

    //Se consolidan los donantes de km
    for (var ranking in rankings) {
      var mainRankingList = rankingsAux.where(
          (mainBuyer) => mainBuyer.userId!.compareTo(ranking.userId!) == 0);

      if (mainRankingList.isEmpty) {
        rankingsAux.add(ranking);
      } else {
        var mainRanking = mainRankingList.first;
        mainRanking.distance = mainRanking.distance! + ranking.distance!;
        mainRanking.totalPurchase =
            mainRanking.totalPurchase! + ranking.totalPurchase!;
      }
    }
    //Ordenamos por km recorridos
    rankingsAux.sort((a, b) => a.compareTo(b));

    for (int i = 0; i < rankingsAux.length; i++) {
      // if (i <= 9) {
      rankingsReturn.add(rankingsAux.elementAt(i));
      // }
    }

    return rankingsReturn;
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    _rankingSubscription?.cancel();
    return super.close();
  }
}
