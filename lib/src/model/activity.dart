enum ActivityStatus {
  nodonate,
  donate,
  purchase,
  waiting,
  manual,
}
enum ActivityType {
  run,
  walk,
  ride;

  String get getString{
    String activityType;
  switch (this) {
    case ActivityType.walk:
      activityType = 'Walk';
      break;
    case ActivityType.ride:
      activityType = 'Ride';
      break;
    default:
      activityType = 'Run';
  }
  return activityType;
}
}

class Activity implements Comparable {
  String? id;
  final String? stravaId;
  String? raceId;
  double? distance;
  DateTime? startDate;
  ActivityStatus status;
  double? totalPurchase;
  ActivityType? type;
  bool? manual;

  get isDonate => status == ActivityStatus.donate ? true : false;
  get isPurchase => status == ActivityStatus.purchase ? true : false;
  get isManual => status == ActivityStatus.manual ? true : false;

  Activity(
      {this.id,
      required this.stravaId,
      this.raceId,
      this.distance,
      this.startDate,
      this.status = ActivityStatus.nodonate,
      this.totalPurchase = 0,
      this.type = ActivityType.run});

  @override
  int compareTo(other) {
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
}
