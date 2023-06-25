import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
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
  late User _user;
  bool _lockStravaLogin = false;
  StreamSubscription? _sessionSubscription;
  // final _checker = AppVersionChecker();
  String? _appVersion;

  UserBloc(this.session, this.factoryDao) : super(UserInitState()) {
    _sessionSubscription = session.stream.listen((state) {
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
    on<DeleteAccountEvent>(_deleteAccountEvent);
    on<UploadUserFieldsEvent>(_uploadUserFieldsEvent);
  }

  void _loadInitialDataEvent(LoadInitialDataEvent event, Emitter emit) async {
    // String currentEdition = Edition.currentEdition;
    try {
      if (_user.isStravaLogin!) {
        if (!PlatformDiscover.isWeb()) {
          if (await factoryDao.userDao.stravaLogIn()) {
            //add(GetStravaActivitiesEvent());
            session.add(StravaLogInSuccessEvent());
          }
        }
      }

      // AppCheckerResult result = await _checker.checkUpdate();
      // _appVersion = result.currentVersion;

      // void checkVersion() async {
      //   _checker.checkUpdate().then((value) {
      //     print(value.canUpdate); //return true if update is available
      //     print(value.currentVersion); //return current app version
      //     print(value.newVersion); //return the new app version
      //     print(value.appURL); //return the app url
      //     print(value.errorMessage); //return error message if found else it will return null
      //   });
      // }

      emit(_uploadUserFields());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError(
              'Algo fue mal al cargar los datos iniciales del usuario!'));
    }
  }

  void _userLogOutEvent(UserLogOutEvent event, Emitter emit) async {
    try {
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

          // add(GetStravaActivitiesEvent());
        }
      }

      emit(_uploadUserFields());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError('Algo fue mal en el Strava Login!'));
    }
  }

  void _deleteAccountEvent(DeleteAccountEvent event, Emitter emit) async {
    try {
      await factoryDao.userDao.deleteAccount(_user.id!);
      session.add(LogoutEvent());
    } catch (error) {
      emit(error is UserStateError
          ? UserStateError(error.message)
          : UserStateError('Algo fue mal en al borrar la cuenta!'));
    }
  }

  void _uploadUserFieldsEvent(UploadUserFieldsEvent event, Emitter emit) async {
    emit(_uploadUserFields());
  }

  UserState _uploadUserFields() => UploadUserFieldsState(
        _user.isStravaLogin,
        _lockStravaLogin,
        _user.fullName,
        _user.photo,
        _appVersion ?? "1.0",
      );

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }
}
