import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:bloc/bloc.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

import 'event/session_event.dart';
import 'event/user_event.dart';
import 'session_bloc.dart';
import 'state/session_state.dart';
import 'state/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FactoryDao factoryDao;
  SessionBloc session;
  User _user = User();
  DateTime _beforeDate;
  DateTime _afterDate;
  List<ActivityPurchase> _donors = [];
  List<ActivityPurchase> _filterDonors = [];
  int _filterDonorTab = 2;
  bool _lockStravaLogin = false;

  UserBloc(this.session, this.factoryDao) {
    this.session.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          this.add(UserLogInEvent());
        }
      } else if (state is LogOutState) {
        this.add(UserLogOutEvent());
      } else if (state is UserChangeState) {
        this._user = state.user;
      }
    });
  }

  @override
  UserState get initialState => UserInitState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLogOutEvent) {
      try {
        if (this._user.isStravaLogin) {
          this.factoryDao.userDao.stravaLogout();
          this._user.isStravaLogin = false;
          this
              .factoryDao
              .userDao
              .saveIsStravaLogin(this._user.id, this._user.isStravaLogin);
        }
        await this.factoryDao.userDao.logOut();
        this._user.logout();
        yield UserLogOutState();
      } catch (error) {
        yield error is UserStateError
            ? UserStateError(error.message)
            : UserStateError('Algo fue mal en el User LogOut!');
      }
    } else if (event is UserLogInEvent) {
      try {
        // this.session.add(UserChangeEvent(this._user));
        this._user = this.session.user;
        yield UserLogInState();
      } catch (error) {
        yield error is UserStateError
            ? UserStateError(error.message)
            : UserStateError('Algo fue mal en el User Login!');
      }
    } else if (event is ConnectWithStravaEvent) {
      try {
        if (this._user.isStravaLogin) {
          await this.session.stravaLogout();
          this._user.isStravaLogin = false;
          this._user.stravaLogout();
          await this
              .factoryDao
              .userDao
              .saveIsStravaLogin(this._user.id, this._user.isStravaLogin);
          this.session.add(UserChangeEvent(this._user));
          _lockStravaLogin = true;
          yield _uploadUserFields();
        } else {
          if (await this.session.stravaLogIn()) {
            this._user.isStravaLogin = true;
            await this
                .factoryDao
                .userDao
                .saveIsStravaLogin(this._user.id, this._user.isStravaLogin);
            this.session.add(UserChangeEvent(this._user));

            this.add(GetStravaActivitiesEvent());
          }
        }

        yield _uploadUserFields();
      } catch (error) {
        yield error is UserStateError
            ? UserStateError(error.message)
            : UserStateError('Algo fue mal en el Strava Login!');
      }
    } else if (event is GetStravaActivitiesEvent) {
      try {
        DateTime now = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 00, 01, 00);

        if (now.isBefore(_beforeDate) && now.isAfter(_afterDate)) {
          List<Activity> stravaActivities = await this
              .factoryDao
              .userDao
              .getStravaActivities(_beforeDate, _afterDate);
          this._user.activities =
              _consolidateActivities(this._user.activities, stravaActivities);
        }
        yield _uploadUserFields();
      } catch (error) {
        yield error is UserStateError
            ? UserStateError(error.message)
            : UserStateError(
                'Algo fue mal al cargar las actividades de Strava del usuario!');
      }
    } else if (event is DonateKmEvent) {
      try {
        Activity activity = this._user.getActivitByStravaId(event.stravaId);
        if (activity != null) {
          activity.status = ActivityStatus.waiting;
          yield _uploadUserFields();
          activity.status = ActivityStatus.donate;
          await this
              .factoryDao
              .userDao
              .donateKm(this._user, '2021DravetTour', activity);
          yield _uploadUserFields();
        }
      } catch (error) {
        yield error is UserStateError
            ? UserStateError(error.message)
            : UserStateError(
                'Algo fue mal al cargar las actividades de Strava del usuario!');
      }
    } else if (event is LoadInitialDataEvent) {
      try {
        this
            .factoryDao
            .userDao
            .getRangeDates('2021DravetTour')
            .listen((rangeDates) async {
          if (rangeDates.isNotEmpty) {
            _beforeDate = rangeDates['before'];
            _afterDate = rangeDates['after'];

            this.add(UploadUserFieldsEvent());
          }

          this
              .factoryDao
              .raceDao
              .streamDonors('2021DravetTour')
              .listen((donors) {
            this._donors = donors;

            // this._filterDonors = _copyDonorsList(this._donors);

            // this._filterDonors = _consolidateAndSortDonors(this._filterDonors);

            // this.add(UploadUserFieldsEvent());

            this.add(ChangeUserPodiumTabEvent(_filterDonorTab));
          });

          if (this._user.isStravaLogin) {
            if (!PlatformDiscover.isWeb()) {
              if (await this.factoryDao.userDao.stravaLogIn()) {
                this.add(GetStravaActivitiesEvent());
              }
            }
          }
        });
      } catch (error) {
        yield error is UserStateError
            ? UserStateError(error.message)
            : UserStateError(
                'Algo fue mal al cargar los datos iniciales del usuario!');
      }
    } else if (event is ChangeUserPodiumTabEvent) {
      try {
        this._filterDonors = _copyDonorsList(this._donors);
        _filterDonorTab = event.indexTab;

        switch (_filterDonorTab) {
          case 1:
            this
                ._filterDonors
                .removeWhere((donor) => donor.type != ActivityType.walk);
            break;
          case 2:
            this
                ._filterDonors
                .removeWhere((donor) => donor.type != ActivityType.run);
            break;
          case 3:
            this
                ._filterDonors
                .removeWhere((donor) => donor.type != ActivityType.ride);
            break;
          default:
        }

        this._filterDonors = _consolidateAndSortDonors(this._filterDonors);
        yield _uploadUserFields();
      } catch (error) {
        yield error is UserStateError
            ? UserStateError(error.message)
            : UserStateError('Algo fue mal al cambiar de pestaña!');
      }
    } else if (event is UploadUserFieldsEvent) {
      yield _uploadUserFields();
    }
  }

  UserState _uploadUserFields() {
    return UploadUserFieldsState(
        this._user.activities,
        this._user.isStravaLogin,
        this._lockStravaLogin,
        this._user.fullName,
        this._user.photo,
        this._beforeDate,
        this._afterDate,
        this._filterDonorTab,
        this._filterDonors);
  }

  List<Activity> _consolidateActivities(
      List<Activity> userActivities, List<Activity> stravaActivities) {
    stravaActivities.forEach((stravaActivity) {
      Iterable<Activity> iterableActivity = userActivities.where((activity) {
        if (activity.stravaId == stravaActivity.stravaId) {
          return true;
        }

        return false;
      });

      if (iterableActivity.isEmpty) {
        userActivities.add(stravaActivity);
      }

      iterableActivity = null;
    });

    userActivities.sort((a, b) => b.startDate.compareTo(a.startDate));

    return userActivities;
  }

  List<ActivityPurchase> _consolidateAndSortDonors(
      List<ActivityPurchase> donors) {
    List<ActivityPurchase> donorsAux = [];
    List<ActivityPurchase> donorsReturn = [];

    //Se consolidan los donantes de km
    donors.forEach((donor) {
      var mainDonorList = donorsAux
          .where((mainBuyer) => mainBuyer.userId.compareTo(donor.userId) == 0);

      if (mainDonorList.isEmpty) {
        donorsAux.add(donor);
      } else {
        var mainDonor = mainDonorList.first;
        mainDonor.distance = mainDonor.distance + donor.distance;
        mainDonor.totalPurchase = mainDonor.totalPurchase + donor.totalPurchase;
      }
    });
    //Ordenamos por km recorridos
    donorsAux.sort((a, b) => a.compareTo(b));

    for (int i = 0; i < donorsAux.length; i++) {
      // if (i <= 9) {
        donorsReturn.add(donorsAux.elementAt(i));
      // }
    }

    return donorsReturn;
  }

  List<ActivityPurchase> _copyDonorsList(List<ActivityPurchase> donors) {
    return donors
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
}
