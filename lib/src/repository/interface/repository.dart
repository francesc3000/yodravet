import 'package:flutter/material.dart';
import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/user_dao.dart';

import 'endpoints.dart';

abstract class Repository implements Endpoints {
  Future<UserDao> getUserById(String userId);
  Future<bool> createUser(
      {@required String id,
      @required String email,
      @required String name,
      @required String lastname,
      String photo});
  Future<bool> saveIsStravaLogin(String userId, bool isStravaLogin);
  Future<bool> donateKm(
      String userId,
      String userFullname,
      String raceId,
      String userStravaId,
      String userPhoto,
      DateTime userRaceDate,
      double km,
      bool userRaceIsDonate,
      bool userRaceIsPurchase,
      double totalPurchase,
      String activityType);
  Stream<RaceDao> streamRaceInfo(String raceId);
  Stream<List<ActivityPurchaseDao>> streamBuyers(String raceId);
  Stream<List<ActivityPurchaseDao>> streamDonors(String raceId);
}
