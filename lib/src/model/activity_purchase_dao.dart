import 'package:yodravet/src/model/activity.dart';

class ActivityPurchaseDao extends Activity {
  String? userId;
  String? userFullname;
  String? userPhoto;

  ActivityPurchaseDao(
      {id,
      stravaId,
      raceId,
      distance,
      startDate,
      totalPurchase,
      type,
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
}
