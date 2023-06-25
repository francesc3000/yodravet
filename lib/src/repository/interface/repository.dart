import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/buyer_dao.dart';
import 'package:yodravet/src/model/collaborator_dao.dart';
import 'package:yodravet/src/model/feed_dao.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/race_spot_dato.dart';
import 'package:yodravet/src/model/ranking_dao.dart';
import 'package:yodravet/src/model/team_dao.dart';
import 'package:yodravet/src/model/user_dao.dart';

import 'endpoints.dart';

abstract class Repository implements Endpoints {
  Future<UserDao> getUserById(String userId, String raceId);
  Future<bool> createUser(
      {required String id,
      required String email,
      required String name,
      required String lastname,
      String? photo});
  Future<bool> acceptUserTerms(String userId);
  Future<bool> saveIsStravaLogin(String userId, bool isStravaLogin);
  Future<bool> donateKm(
      String userId,
      String userFullname,
      String raceId,
      String? teamId,
      String userStravaId,
      String userPhoto,
      DateTime userRaceDate,
      double km,
      bool userRaceIsDonate,
      bool userRaceIsPurchase,
      double totalPurchase,
      String activityType);
  Stream<RaceDao?> streamRaceInfo(String raceId);
  Stream<List<BuyerDao>> streamBuyers(String raceId);
  Stream<List<ActivityPurchaseDao>> streamDonors(String raceId, String userId);
  Stream<List<RankingDao>> streamRanking(String raceId);
  Future<List<CollaboratorDao>> getCollaborators();
  Stream<List<TeamDao>?> streamTeams();
  Future<bool> changeUserTeam(String mode, String userId, String teamId);
  Stream<List<RaceSpotDao>> streamRaceSpot(String raceId);
  Stream<List<String>> streamSpotVotes(String userId, String raceId);
  Future<bool> spotThumbUp(String userId, String raceId, String spotId);
  Future<bool> spotThumbDown(String userId, String raceId, String spotId);
  Stream<List<FeedDao>> streamFeed(
      String raceId, FeedDao? afterDocument, int limit);
  Future<bool> deleteUserAccount(String userId);
}
