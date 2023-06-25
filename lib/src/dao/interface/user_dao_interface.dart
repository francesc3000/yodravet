import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/user.dart';

abstract class UserDaoInterface {
  Future<String> logIn(String email, String pass);
  Future<User> googleLogIn();
  Future<User> appleLogIn();
  Future<bool> stravaLogIn();
  Future<bool> stravaLogout();
  Future<bool> logOut();
  Future<User> populateUser(String userId, String raceId);
  Future<String?> isUserLoggedIn();
  Future<bool> changePassword(String email);
  Future<String> createAuthUser(String email, String password);
  Future<bool> createUser(
      String id, String email, String name, String lastname, String photo);
  Future<bool> acceptUserTerms(String userId);
  Future<bool> saveIsStravaLogin(String userId, bool isStravaLogin);
  Future<List<Activity>> getStravaActivities(DateTime before, DateTime after);
  Future<bool> donateKm(User user, String raceId, Activity activity);
  Stream<Map<String, DateTime?>> getRangeDates(String raceId);
  Future<bool> joinTeam(String userId, String teamId);
  Future<bool> disJoinTeam(String userId, String teamId);
  Stream<List<String>> streamSpotVotes(String userId, String raceId);
  Future<bool> spotThumbUp(String userId, String raceId, String spotId);
  Future<bool> spotThumbDown(String userId, String raceId, String spotId);
  Future<bool> deleteAccount(String userId);
}
