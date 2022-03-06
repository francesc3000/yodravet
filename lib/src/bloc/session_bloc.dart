import 'package:flutter/foundation.dart';
import 'package:yodravet/src/bloc/state/session_state.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

import 'event/session_event.dart';
import 'interface/session_interface.dart';

class SessionBloc extends Session {
  final FactoryDao _factoryDao;

  SessionBloc(this._factoryDao) : super(SessionStateEmpty());

  @override
  Future autoLogIn([
    String? userEmail = '',
    String? password = '',
  ]) async {
    if (kDebugMode) {
      print('Estoy en autologin en session_bloc');
    }
    String? userId = await _isUserLoggedIn();
    if (kDebugMode) {
      print('userId: $userId');
    }

    if(userId==null) {
      add(SignedEvent(false, true));
    } else {
      user = await _populateUser(userId);
      if (user.isLogin) {
        add(SignedEvent(true, true));
      } else {
        add(SignedEvent(false, true));
      }
    }


  }

  Future<String?> _isUserLoggedIn() async {
    if (kDebugMode) {
      print('Estoy en UserLoggedIn en session_bloc');
    }
    return await _factoryDao.userDao.isUserLoggedIn();
  }

  @override
  Future<User> logIn(String userEmail, String password) async =>
      await _logIn(userEmail, password);

  Future<User> _logIn(String email, String password) async {
    if (kDebugMode) {
      print('Estoy en login en session_bloc');
    }
    this.password = password;
    String userId = '';
    try {
      userId = await _factoryDao.userDao.logIn(email, password);
    } on String catch (e) {
      throw SessionStateError(e);
    }

    user = await _populateUser(userId);
    if (user.isLogin) {
      if (kDebugMode) {
        print('Salgo de login en session_bloc ha ido bien el login');
      }
      if (!PlatformDiscover.isWeb()) {
        // this.user.isStravaLogin = await this._factoryDao.userDao
        // .stravaLogIn();
      }
      add(SignedEvent(true, false));
    } else {
      if (kDebugMode) {
        print('Salgo del login en sessio_bloc no se ha podido hacer el login');
      }
      add(SignedEvent(false, false));
    }

    return user;
  }

  @override
  Future<User> googleLogIn() async {
    User googleUser = await _factoryDao.userDao.googleLogIn();

    if (googleUser.isLogin) {
      user = await _populateUser(googleUser.id);
      if (!user.isLogin) {
        user = googleUser;
        //Si no se encuentra en base de datos se crea el usuario
        await _factoryDao.userDao.createUser(
            user.id, user.email, user.name, user.lastname, user.photo);
      }
      if (kDebugMode) {
        print('Salgo de login en session_bloc ha ido bien el login');
      }

      add(SignedEvent(true, false));
    } else {
      add(SignedEvent(false, false));
    }

    return user;
  }

  @override
  Future<User> appleLogIn() async {
    User appleUser = await _factoryDao.userDao.appleLogIn();

    if (appleUser.isLogin) {
      user = await _populateUser(appleUser.id);
      if (!user.isLogin) {
        user = appleUser;
        //Si no se encuentra en base de datos se crea el usuario
        await _factoryDao.userDao.createUser(
            user.id, user.email, user.name, user.lastname, user.photo);
      }
      if (kDebugMode) {
        print('Salgo de login en session_bloc ha ido bien el login');
      }

      add(SignedEvent(true, false));
    } else {
      add(SignedEvent(false, false));
    }

    return user;
  }

  Future<User> _populateUser(String? userId) async =>
      await _factoryDao.userDao.populateUser(userId);

  @override
  Future<bool> stravaLogIn() async => await _factoryDao.userDao.stravaLogIn();

  @override
  Future<bool> stravaLogout() async => await _factoryDao.userDao.stravaLogout();

  @override
  void logout() {
    user.logout();
    //this.add(SignedEvent(false));
    _factoryDao.userDao.logOut();
  }

  @override
  Future<bool> changePassword(String email) async =>
      await _factoryDao.userDao.changePassword(email);

  @override
  Future signup(String? email, String? password, String? name, String? lastname,
      String? photo) async {
    //Se crea el usuario Auth
    String uid = await _factoryDao.userDao.createAuthUser(email!, password!);

    //Se crea el usuario en ruta user
    await _factoryDao.userDao.createUser(uid, email, name, lastname, photo);

    user = User(
        id: uid,
        email: email,
        name: name,
        lastname: lastname,
        photo: photo,
        isStravaLogin: false);

    add(SignedEvent(true, false));
  }
}
