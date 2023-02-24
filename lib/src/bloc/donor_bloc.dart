import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yodravet/src/bloc/event/session_event.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/team.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/shared/edition.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

import 'event/donor_event.dart';
import 'session_bloc.dart';
import 'state/donor_state.dart';
import 'state/session_state.dart';

class DonorBloc extends Bloc<DonorEvent, DonorState> {
  final FactoryDao factoryDao;
  final SessionBloc session;
  StreamSubscription? _sessionSubscription;
  StreamSubscription? _userSubscription;
  StreamSubscription? _teamSubscription;
  User? _user;
  DateTime? _beforeDate;
  DateTime? _afterDate;
  List<Team>? _teams;

  DonorBloc(this.session, this.factoryDao) : super(DonorInitState()) {
    _sessionSubscription = session.stream.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          _user = session.user;
        }
      } else if (state is LogOutState) {
        _user = null;
      } else if (state is UserChangeState) {
        _user = session.user;
      } else if (state is StravaLogInSuccessState) {
        add(GetStravaActivitiesEvent());
      }
    });

    _user = session.user;

    on<LoadInitialDataEvent>(_loadInitialDataEvent);
    on<DonateKmEvent>(_donateKmEvent);
    on<GetStravaActivitiesEvent>(_getStravaActivitiesEvent);
    on<ShareActivityEvent>(_shareActivityEvent);
    on<JoinTeamEvent>(_joinTeamEvent);
    on<DisJoinTeamEvent>(_disJoinTeamEvent);
    on<UploadDonorFieldsEvent>(_uploadDonorFieldsEvent);
  }

  void _loadInitialDataEvent(LoadInitialDataEvent event, Emitter emit) async {
    String currentEdition = Edition.currentEdition;
    try {
      _userSubscription = factoryDao.userDao
          .getRangeDates(currentEdition)
          .listen((rangeDates) async {
        if (rangeDates.isNotEmpty) {
          _beforeDate = rangeDates['before'];
          _afterDate = rangeDates['after'];

          add(UploadDonorFieldsEvent());
        }

        if (_user!.isStravaLogin!) {
          if (!PlatformDiscover.isWeb()) {
            if (await factoryDao.userDao.stravaLogIn()) {
              add(GetStravaActivitiesEvent());
            }
          }
        }
      });

      _teamSubscription = factoryDao.teamDao.getTeams().listen((teams) async {
        _teams = teams;

        add(UploadDonorFieldsEvent());
      });
    } catch (error) {
      emit(error is DonorStateError
          ? DonorStateError(error.message)
          : DonorStateError(
              'Algo fue mal al cargar los datos iniciales del usuario!'));
    }
  }

  void _getStravaActivitiesEvent(
      GetStravaActivitiesEvent event, Emitter emit) async {
    try {
      DateTime now = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 00, 01, 00);
      if (now.isBefore(_beforeDate!) && now.isAfter(_afterDate!)) {
      List<Activity> stravaActivities = await factoryDao.userDao
          .getStravaActivities(_beforeDate!, _afterDate!);
      _user!.activities =
          _consolidateActivities(_user!.activities!, stravaActivities);
      }
      emit(_uploadDonorFields());
    } catch (error) {
      emit(error is DonorStateError
          ? DonorStateError(error.message)
          : DonorStateError(
              'Algo fue mal al cargar las actividades de Strava del usuario!'));
    }
  }

  void _donateKmEvent(DonateKmEvent event, Emitter emit) async {
    try {
      String currentEdition = Edition.currentEdition;
      Activity activity = _user!.getActivitiesByStravaId(event.stravaId);
      activity.status = ActivityStatus.waiting;
      emit(_uploadDonorFields());
      activity.status = ActivityStatus.donate;
      await factoryDao.userDao.donateKm(_user!, currentEdition, activity);
      emit(_uploadDonorFields());
    } catch (error) {
      emit(error is DonorStateError
          ? DonorStateError(error.message)
          : DonorStateError(
              'Algo fue mal al donar km!'));
    }
  }

  void _shareActivityEvent(ShareActivityEvent event, Emitter emit) async {
    Share.share(event.message2Share);
  }

  void _joinTeamEvent(JoinTeamEvent event, Emitter emit) async {
    await factoryDao.userDao.joinTeam(_user!.id!, event.teamId);

    _user!.teamId = event.teamId;
    session.add(UserChangeEvent(_user!));
    emit(_uploadDonorFields());
  }

  void _disJoinTeamEvent(DisJoinTeamEvent event, Emitter emit) async {
    await factoryDao.userDao.disJoinTeam(_user!.id!, event.teamId);

    _user!.teamId = null;
    session.add(UserChangeEvent(_user!));
    emit(_uploadDonorFields());
  }

  void _uploadDonorFieldsEvent(
      UploadDonorFieldsEvent event, Emitter emit) async {
    emit(_uploadDonorFields());
  }

  DonorState _uploadDonorFields() => UploadDonorFieldsState(
        _user!.activities,
        _teams,
        _user!.teamId,
        _beforeDate,
        _afterDate,
      );

  List<Activity> _consolidateActivities(
      List<Activity> donorActivities, List<Activity> stravaActivities) {
    for (var stravaActivity in stravaActivities) {
      Iterable<Activity> iterableActivity = donorActivities.where((activity) {
        if (activity.stravaId == stravaActivity.stravaId) {
          return true;
        }

        return false;
      });

      if (iterableActivity.isEmpty) {
        donorActivities.add(stravaActivity);
      }
    }

    donorActivities.sort((a, b) => b.startDate!.compareTo(a.startDate!));

    return donorActivities;
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    _userSubscription?.cancel();
    _teamSubscription?.cancel();
    return super.close();
  }
}
