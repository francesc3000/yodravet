import 'dart:async';

import 'package:strava_client/strava_client.dart';
import 'package:yodravet/src/model/activity_dao.dart';
import 'package:yodravet/src/shared/secret.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/strava_interface.dart';

class StravaImpl extends StravaInterface {
  final StravaClient _strava = StravaClient(secret: secret, clientId: clientId);

  @override
  Future<bool> stravaLogIn() async {
    List<AuthenticationScope> scopes = [AuthenticationScope.activity_read_all];
    await _strava.authentication.authenticate(
        scopes: scopes,
        redirectUrl: "stravaflutter://redirect",
        // redirectUrl: "flutterstrava://redirect",
        callbackUrlScheme: "stravaflutter"
        // callbackUrlScheme: "flutterstrava"
        ).onError((TokenResponse error, stackTrace) async{
          await logOut();
          return error;
    });
    return true;
  }

  @override
  Future<bool> logOut() async {
    await _strava.authentication.deAuthorize();

    return true;
  }

  @override
  Future<bool> isLogIn() async {
    TokenResponse token =
        await (_strava.getStravaAuthToken() as FutureOr<TokenResponse>);
    if (token.accessToken == 'null') return false;

    DateTime expiresAt = DateTime.fromMillisecondsSinceEpoch(token.expiresAt);
    if (expiresAt.compareTo(DateTime.now()) == 1) return false;

    return true;
  }

  @override
  Future<List<ActivityDao>> getStravaActivities(
      DateTime before, DateTime after) async {
    try {
      //TODO: Gestionar paginas de actividades en listLoggedInAthleteActivities
      List<SummaryActivity> stravaActivities = await _strava.activities
          .listLoggedInAthleteActivities(before, after, 1, 20);

      return stravaActivities
          .map<ActivityDao>((activity) => TransformModel.raw2ActivityDao(
              stravaId: activity.id.toString(),
              distance: activity.distance,
              startDate: DateTime.parse(activity.startDate!),
              type: activity.type,
              isManual: activity.manual!))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
