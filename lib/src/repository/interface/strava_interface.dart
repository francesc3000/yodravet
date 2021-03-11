import 'package:yodravet/src/model/activity_dao.dart';

abstract class StravaInterface {
  Future<bool> stravaLogIn();
  Future<bool> logOut();
  Future<bool> isLogIn();
  Future<List<ActivityDao>> getStravaActivities(DateTime before, DateTime after);
}