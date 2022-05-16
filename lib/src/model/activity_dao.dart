import 'package:yodravet/src/model/activity.dart';

class ActivityDao {
  String? id;
  String? stravaId;
  String? raceId;
  double? distance;
  DateTime? startDate;
  ActivityStatus status;
  double? totalPurchase;
  ActivityType? type;

  ActivityDao(
      {this.id,
      required this.stravaId,
      this.raceId,
      this.distance,
      this.startDate,
      this.status = ActivityStatus.nodonate,
      this.totalPurchase = 0,
      this.type = ActivityType.run});
}
