import 'package:flutter/foundation.dart';
import 'package:yodravet/src/bloc/state/session_state.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/user.dart';

import 'event/session_event.dart';
import 'interface/session_interface.dart';

class SessionBloc extends Session {
  FactoryDao _factoryDao;

  SessionBloc(this._factoryDao);

  @override
  Future autoLogIn([
    String userEmail = '',
    String password = '',
  ]) async {
    print('Estoy en autologin en session_bloc');
    String userId = await _isUserLoggedIn();
    print('userId: $userId');

    this.user = await _populateUser(userId);
    if (this.user.isLogin) {
      this.add(SignedEvent(true, true));
    } else {
      this.add(SignedEvent(false, true));
    }
  }

  Future<String> _isUserLoggedIn() async {
    print('Estoy en UserLoggedIn en session_bloc');
    return await this._factoryDao.userDao.isUserLoggedIn();
  }

  @override
  Future<User> logIn(String email, String password) async {
    return await _logIn(email, password);
  }

  Future<User> _logIn(String email, String password) async {
    print('Estoy en login en session_bloc');
    this.password = password;
    String userId = '';
    try {
      userId = await this._factoryDao.userDao.logIn(email, password);
    } catch (e) {
      throw SessionStateError(e);
    }

    this.user = await _populateUser(userId);
    if (user.isLogin) {
      print('Salgo de login en session_bloc ha ido bien el login');
      if(!kIsWeb) {
        // this.user.isStravaLogin = await this._factoryDao.userDao.stravaLogIn();
      }
      this.add(SignedEvent(true, false));
    } else {
      print('Salgo del login en sessio_bloc no se ha podido hacer el login');
      this.add(SignedEvent(false, false));
    }

    return this.user;
  }

  @override
  Future<User> googleLogIn() async{
    User googleUser =  await this._factoryDao.userDao.googleLogIn();

    if (googleUser.isLogin) {
      this.user = await _populateUser(googleUser.id);
      if(!this.user.isLogin) {
        this.user = googleUser;
        //Si no se encuentra en base de datos se crea el usuario
        await this._factoryDao.userDao.createUser(user.id, user.email, user.name, user.lastname, user.photo);
      }
      print('Salgo de login en session_bloc ha ido bien el login');

      this.add(SignedEvent(true, false));
    } else {
      this.add(SignedEvent(false, false));
    }

    return this.user;

  }

  @override
  Future<User> appleLogIn() async{
    User appleUser =  await this._factoryDao.userDao.appleLogIn();

    if (appleUser.isLogin) {
      this.user = await _populateUser(appleUser.id);
      if(!this.user.isLogin) {
        this.user = appleUser;
        //Si no se encuentra en base de datos se crea el usuario
        await this._factoryDao.userDao.createUser(user.id, user.email, user.name, user.lastname, user.photo);
      }
      print('Salgo de login en session_bloc ha ido bien el login');

      this.add(SignedEvent(true, false));
    } else {
      this.add(SignedEvent(false, false));
    }

    return this.user;

  }

  Future<User> _populateUser(String userId) async {
    return await this._factoryDao.userDao.populateUser(userId);
  }

  @override
  Future<bool> stravaLogIn() async{
    return await this._factoryDao.userDao.stravaLogIn();
  }

  @override
  Future<bool> stravaLogout() async{
    return await this._factoryDao.userDao.stravaLogout();
  }

  @override
  void logout() {
    this.user.logout();
    //this.add(SignedEvent(false));
    this._factoryDao.userDao.logOut();
  }

  @override
  Future<bool> changePassword(String email) async {
    return await this._factoryDao.userDao.changePassword(email);
  }

  @override
  Future signup(String email, String password, String name, String lastname, String photo) async {
    //Se crea el usuario Auth
    String uid = await this._factoryDao.userDao.createAuthUser(email, password);

    //Se crea el usuario en ruta user 
    await this._factoryDao.userDao.createUser(uid, email, name, lastname, photo);

    this.user = User(
        id: uid,
        email: email,
        name: name,
        lastname: lastname,
        photo: photo,
        isStravaLogin: false);

    this.add(SignedEvent(true, false));
  }
}
