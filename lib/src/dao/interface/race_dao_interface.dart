import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/race_spot.dart';
import 'package:yodravet/src/model/ranking.dart';

abstract class RaceDaoInterface {
  Stream<Race?> streamRaceInfo(String raceId);
  Stream<List<Buyer>> streamBuyers(String raceId);
  Stream<List<Activity>> streamDonors(String raceId, String userId);
  Stream<List<Ranking>> streamRanking(String raceId);
  Stream<List<RaceSpot>> streamRaceSpot(String raceId);
}