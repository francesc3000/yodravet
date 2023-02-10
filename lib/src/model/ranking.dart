import 'package:yodravet/src/model/activity.dart';

class Ranking extends Comparable{
  String id;
  double? run;
  double? walk;
  double? ride;
  bool isTeam;
  String userFullname;
  String userPhoto;
  ActivityType mainActivity = ActivityType.run;

  Ranking(this.id, this.run, this.walk, this.ride, this.isTeam,
      this.userFullname, this.userPhoto);

  setMainActivity(ActivityType mainActivity) {
    this.mainActivity = mainActivity;
  }

  @override
  int compareTo(other) {
    if(other is Ranking) {
      double distance;
      double otherDistance;
      switch (mainActivity) {
        case ActivityType.run:
          distance = run ?? 0;
          otherDistance = other.run ?? 0;
          break;
        case ActivityType.walk:
          distance = walk ?? 0;
          otherDistance = other.walk ?? 0;
          break;
        case ActivityType.ride:
          distance = ride ?? 0;
          otherDistance = other.ride ?? 0;
          break;
      }
      if (distance < otherDistance) {
        return 1;
      }

      if (distance > otherDistance) {
        return -1;
      }
    }

    return 0;
  }
}
