import 'package:bloc/bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/shared/edition.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

import 'event/session_event.dart';
import 'event/user_event.dart';
import 'session_bloc.dart';
import 'state/session_state.dart';
import 'state/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FactoryDao factoryDao;
  SessionBloc session;
  late User _user;
  DateTime? _beforeDate;
  DateTime? _afterDate;
  List<ActivityPurchase> _donors = [];
  List<ActivityPurchase> _filterDonors = [];
  int _filterDonorTab = 2;
  bool _lockStravaLogin = false;
  // String _usuarios = '';

  UserBloc(this.session, this.factoryDao) : super(UserInitState()) {
    session.stream.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          add(UserLogInEvent());
        }
      } else if (state is LogOutState) {
        add(UserLogOutEvent());
      } else if (state is UserChangeState) {
        _user = state.user;
      }
    });

    _user = session.user;

    on<LoadInitialDataEvent>(_loadInitialDataEvent);
    on<UserLogOutEvent>(_userLogOutEvent);
    on<UserLogInEvent>(_userLogInEvent);
    on<ConnectWithStravaEvent>(_connectWithStravaEvent);
    on<GetStravaActivitiesEvent>(_getStravaActivitiesEvent);
    on<DonateKmEvent>(_donateKmEvent);
    on<ShowPodiumEvent>(_showPodiumEvent);
    on<ChangeUserPodiumTabEvent>(_changeUserPodiumTabEvent);
    on<UploadUserFieldsEvent>(_uploadUserFieldsEvent);
    on<ShareActivityEvent>(_shareActivityEvent);
  }

  void _loadInitialDataEvent(LoadInitialDataEvent event, Emitter emit) async {
    String currentEdition = Edition.currentEdition;
    try {
      factoryDao.userDao
          .getRangeDates(currentEdition)
          .listen((rangeDates) async {
        if (rangeDates.isNotEmpty) {
          _beforeDate = rangeDates['before'];
          _afterDate = rangeDates['after'];

          add(UploadUserFieldsEvent());
        }

        if (_user.isStravaLogin!) {
          if (!PlatformDiscover.isWeb()) {
            if (await factoryDao.userDao.stravaLogIn()) {
              add(GetStravaActivitiesEvent());
            }
          }
        }
      });
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError(
              'Algo fue mal al cargar los datos iniciales del usuario!'));
    }
  }

  void _userLogOutEvent(UserLogOutEvent event, Emitter emit) async {
    try {
      if (_user.isStravaLogin!) {
        factoryDao.userDao.stravaLogout();
        _user.isStravaLogin = false;
        factoryDao.userDao.saveIsStravaLogin(_user.id, _user.isStravaLogin);
      }
      await factoryDao.userDao.logOut();
      _user.logout();
      emit(UserLogOutState());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError('Algo fue mal en el User LogOut!'));
    }
  }

  void _userLogInEvent(UserLogInEvent event, Emitter emit) async {
    try {
      // this.session.add(UserChangeEvent(this._user));
      _user = session.user;
      emit(UserLogInState());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError('Algo fue mal en el User Login!'));
    }
  }

  void _connectWithStravaEvent(
      ConnectWithStravaEvent event, Emitter emit) async {
    try {
      if (_user.isStravaLogin!) {
        await session.stravaLogout();
        _user.isStravaLogin = false;
        _user.stravaLogout();
        await factoryDao.userDao
            .saveIsStravaLogin(_user.id, _user.isStravaLogin);
        session.add(UserChangeEvent(_user));
        _lockStravaLogin = true;
        emit(_uploadUserFields());
      } else {
        if (await session.stravaLogIn()) {
          _user.isStravaLogin = true;
          await factoryDao.userDao
              .saveIsStravaLogin(_user.id, _user.isStravaLogin);
          session.add(UserChangeEvent(_user));

          add(GetStravaActivitiesEvent());
        }
      }

      emit(_uploadUserFields());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError('Algo fue mal en el Strava Login!'));
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
        _user.activities =
            _consolidateActivities(_user.activities!, stravaActivities);
      }
      emit(_uploadUserFields());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError(
              'Algo fue mal al cargar las actividades de Strava del usuario!'));
    }
  }

  void _donateKmEvent(DonateKmEvent event, Emitter emit) async {
    try {
      String currentEdition = Edition.currentEdition;
      Activity activity = _user.getActivitiesByStravaId(event.stravaId);
      activity.status = ActivityStatus.waiting;
      emit(_uploadUserFields());
      activity.status = ActivityStatus.donate;
      await factoryDao.userDao.donateKm(_user, currentEdition, activity);
      emit(_uploadUserFields());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError(
              'Algo fue mal al cargar las actividades de Strava del usuario!'));
    }
  }

  void _showPodiumEvent(ShowPodiumEvent event, Emitter emit) async {
    String currentEdition = Edition.currentEdition;
    try {
      factoryDao.raceDao.streamDonors(currentEdition).listen((donors) {
        _donors = donors;

        // this._filterDonors = _copyDonorsList(this._donors);

        // this._filterDonors = _consolidateAndSortDonors(this._filterDonors);

        // this.add(UploadUserFieldsEvent());

        add(ChangeUserPodiumTabEvent(_filterDonorTab));
      });
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError(
              'Algo fue mal al cargar los datos iniciales del usuario!'));
    }
  }

  void _changeUserPodiumTabEvent(
      ChangeUserPodiumTabEvent event, Emitter emit) async {
    try {
      _filterDonors = _copyDonorsList(_donors);
      _filterDonorTab = event.indexTab;

      switch (_filterDonorTab) {
        case 1:
          _filterDonors.removeWhere((donor) => donor.type != ActivityType.walk);
          break;
        case 2:
          _filterDonors.removeWhere((donor) => donor.type != ActivityType.run);
          break;
        case 3:
          _filterDonors.removeWhere((donor) => donor.type != ActivityType.ride);
          break;
        default:
      }

      _filterDonors = _consolidateAndSortDonors(_filterDonors);
      emit(_uploadUserFields());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError('Algo fue mal al cambiar de pestaña!'));
    }
  }

  void _uploadUserFieldsEvent(UploadUserFieldsEvent event, Emitter emit) async {
    emit(_uploadUserFields());
  }

  void _shareActivityEvent(ShareActivityEvent event, Emitter emit) async {
    Share.share(event.message2Share);
  }

  UserState _uploadUserFields() => UploadUserFieldsState(
      _user.activities,
      _user.isStravaLogin,
      _lockStravaLogin,
      _user.fullName,
      _user.photo,
      _beforeDate,
      _afterDate,
      _filterDonorTab,
      _filterDonors
      // _usuarios
      );

  List<Activity> _consolidateActivities(
      List<Activity> userActivities, List<Activity> stravaActivities) {
    for (var stravaActivity in stravaActivities) {
      Iterable<Activity> iterableActivity = userActivities.where((activity) {
        if (activity.stravaId == stravaActivity.stravaId) {
          return true;
        }

        return false;
      });

      if (iterableActivity.isEmpty) {
        userActivities.add(stravaActivity);
      }
    }

    userActivities.sort((a, b) => b.startDate!.compareTo(a.startDate!));

    return userActivities;
  }

  List<ActivityPurchase> _consolidateAndSortDonors(
      List<ActivityPurchase> donors) {
    List<ActivityPurchase> donorsAux = [];
    List<ActivityPurchase> donorsReturn = [];

    //Se consolidan los donantes de km
    for (var donor in donors) {
      var mainDonorList = donorsAux.where(
          (mainBuyer) => mainBuyer.userId!.compareTo(donor.userId!) == 0);

      if (mainDonorList.isEmpty) {
        donorsAux.add(donor);
      } else {
        var mainDonor = mainDonorList.first;
        mainDonor.distance = mainDonor.distance! + donor.distance!;
        mainDonor.totalPurchase =
            mainDonor.totalPurchase! + donor.totalPurchase!;
      }
    }
    //Ordenamos por km recorridos
    donorsAux.sort((a, b) => a.compareTo(b));

    for (int i = 0; i < donorsAux.length; i++) {
      // if (i <= 9) {
      donorsReturn.add(donorsAux.elementAt(i));
      // }
    }

    return donorsReturn;
  }

  List<ActivityPurchase> _copyDonorsList(List<ActivityPurchase> donors) =>
      donors
          .map((donor) => ActivityPurchase(
                id: donor.id,
                stravaId: donor.stravaId,
                distance: donor.distance,
                raceId: donor.raceId,
                startDate: donor.startDate,
                totalPurchase: donor.totalPurchase,
                type: donor.type,
                userFullname: donor.userFullname,
                userId: donor.userId,
                userPhoto: donor.userPhoto,
              ))
          .toList();
}
