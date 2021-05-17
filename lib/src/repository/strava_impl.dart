import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_flutter/Models/fault.dart';
import 'package:strava_flutter/Models/token.dart';
import 'package:strava_flutter/strava.dart';
import 'package:yodravet/src/model/activity_dao.dart';
import 'package:yodravet/src/shared/secret.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/strava_interface.dart';

class StravaImpl extends StravaInterface {
  final Strava _strava = Strava(false, secret);

  @override
  Future<bool> stravaLogIn() async {
    return await _strava.oauth(
        clientId, 'activity:read_all', secret, 'auto');
  }

  @override
  Future<bool> logOut() async {
    Fault fault = await _strava.deAuthorize();
    if (fault.statusCode == 0){
      _strava.dispose();
      return true;
    }

    return false;
  }

  @override
  Future<bool> isLogIn() async {
    Token token = await _strava.getStoredToken();
    if (token.accessToken == 'null') return false;

    DateTime expiresAt = DateTime.fromMillisecondsSinceEpoch(token.expiresAt);
    if (expiresAt.compareTo(DateTime.now()) == 1) return false;

    return true;
  }

  @override
  Future<List<ActivityDao>> getStravaActivities(DateTime before, DateTime after) async {
    try {
      List<SummaryActivity> stravaActivities =
          await _strava.getLoggedInAthleteActivities(
            Timestamp.fromDate(before).seconds
            ,
            Timestamp.fromDate(after).seconds
            );

      return stravaActivities
          .map<ActivityDao>((activity) => TransformModel.raw2ActivityDao(
                stravaId: activity.id.toString(),
                distance: activity.distance,
                startDate: activity.startDate,
                type: activity.type,
                isManual: activity.manual
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
