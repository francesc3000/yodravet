import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_dao.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/model/user_dao.dart';
import 'package:yodravet/src/repository/auth_firebase_repository_impl.dart';
import 'package:yodravet/src/repository/firestore_repository_impl.dart';
import 'package:yodravet/src/repository/strava_impl.dart';
import 'package:yodravet/src/shared/transform_model.dart';
import 'interface/user_dao_interface.dart';

class UserDaoImpl extends UserDaoInterface {
  final AuthFirebaseRepositoryImpl _auth = AuthFirebaseRepositoryImpl();
  final FirestoreRepositoryImpl firestore;
  final StravaImpl _strava = StravaImpl();

  UserDaoImpl(this.firestore);

  @override
  Future<String> logIn(String email, String pass) async =>
      await _auth.logIn(email, pass);

  @override
  Future<User> googleLogIn() async =>
      TransformModel.userDao2User(await _auth.googleLogIn());

  @override
  Future<User> appleLogIn() async =>
      TransformModel.userDao2User(await _auth.appleLogIn());

  @override
  Future<User> populateUser(String? userId, String raceId) async {
    UserDao userDao;

    try {
      userDao = await firestore.getUserById(userId, raceId);
    } catch (e) {
      userDao = UserDao();
    }

    return TransformModel.userDao2User(userDao);
  }

  @override
  Future<String?> isUserLoggedIn() async {
    if (kDebugMode) {
      print('Estoy en UserLoggedIn en user_dao');
    }
    return await _auth.isUserLoggedIn();
  }

  @override
  Future<bool> logOut() async => await _auth.logOut();

  @override
  Future<bool> changePassword(String email) async =>
      await _auth.changePassword(email);

  @override
  Future<String> createAuthUser(String email, String password) =>
      _auth.createAuthUser(email, password);

  @override
  Future<bool> createUser(String? id, String? email, String? name,
      String? lastname, String? photo) async {
    await firestore.createUser(
        id: id, email: email, name: name, lastname: lastname, photo: photo);

    return true;
  }

  @override
  Future<bool> stravaLogIn() async => await _strava.stravaLogIn();

  @override
  Future<bool> stravaLogout() async => await _strava.logOut();

  @override
  Future<bool> donateKm(User user, String raceId, Activity activity) async =>
      await firestore.donateKm(
          user.id,
          user.fullName,
          raceId,
          user.teamId,
          activity.stravaId,
          user.photo,
          activity.startDate,
          activity.distance,
          activity.isDonate,
          activity.isPurchase,
          activity.totalPurchase,
          activity.type!.getString);

  @override
  Future<List<Activity>> getStravaActivities(
      DateTime before, DateTime after) async {
    List<ActivityDao> activitiesDao =
        await _strava.getStravaActivities(before, after);
    return TransformModel.activitiesDao2Activities(activitiesDao);
  }

  @override
  Stream<Map<String, DateTime?>> getRangeDates(String raceId) =>
      firestore.streamRaceInfo(raceId).transform<Map<String, DateTime?>>(
        StreamTransformer<RaceDao?, Map<String, DateTime?>>.fromHandlers(
            handleData: (raceDao, sink) {
          sink.add({'before': raceDao?.finalDate, 'after': raceDao?.startDate});
        }),
      );

  @override
  Future<bool> saveIsStravaLogin(String? userId, bool? isStravaLogin) async =>
      await firestore.saveIsStravaLogin(userId, isStravaLogin);

  @override
  Future<bool> joinTeam(String userId, String teamId) async =>
      await firestore.changeUserTeam('J', userId, teamId);

  @override
  Future<bool> disJoinTeam(String userId, String teamId) async =>
      await firestore.changeUserTeam('D', userId, teamId);
}
