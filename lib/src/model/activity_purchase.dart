import 'package:yodravet/src/model/activity.dart';

class ActivityPurchase extends Activity {
  String? userId;
  String? userFullname;
  String? userPhoto;

  ActivityPurchase(
      {String? id,
      String? stravaId,
      String? raceId,
      double? distance,
      DateTime? startDate,
      double? totalPurchase,
      ActivityType? type,
      this.userId = '',
      this.userFullname = '',
      this.userPhoto = ''})
      : super(
            id: id,
            stravaId: stravaId,
            raceId: raceId,
            distance: distance,
            startDate: startDate,
            status: ActivityStatus.purchase,
            totalPurchase: totalPurchase,
            type: type);

  @override
  int compareTo(other) {
    if (totalPurchase! < other.totalPurchase) {
      return 1;
    }

    if (totalPurchase! > other.totalPurchase) {
      return -1;
    }

    if (totalPurchase == other.totalPurchase) {
      // if (other?.butterfly != null) {
      //   if (distance! < other.butterfly) {
      //     return 1;
      //   }
      //
      //   if (distance! > other.butterfly) {
      //     return -1;
      //   }
      // }
      if (distance! < other.distance) {
        return 1;
      }

      if (distance! > other.distance) {
        return -1;
      }

      if (distance == other.distance) {
        return 0;
      }

      return 0;
    }
    return 0;
  }
}
