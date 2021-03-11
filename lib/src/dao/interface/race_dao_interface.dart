import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/race.dart';

abstract class RaceDaoInterface {
  Stream<Race> streamRaceInfo(String raceId);
  Stream<List<ActivityPurchase>> streamBuyers(String raceId);
  Stream<List<Activity>> streamDonors(String raceId);
}