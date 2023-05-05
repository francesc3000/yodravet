import 'activity.dart';

class User {
  String? id;
  String? email;
  String? name;
  String? lastname;
  String? photo;
  String? teamId;
  List<Activity>? activities;
  bool? isStravaLogin;
  bool isTermsOn;

  String get fullName => '$name $lastname';
  bool get isLogin => id!.isNotEmpty;

  User(
      {this.id = '',
      this.email = '',
      this.name = '',
      this.lastname = '',
      this.photo = '',
      this.isStravaLogin = false,
        this.teamId,
      this.activities,
      this.isTermsOn = false}) {
    activities ??= [];
  }

  void logout() {
    id = '';
    email = '';
    name = '';
    lastname = '';
    photo = '';
    activities = [];
    isStravaLogin = false;
    isTermsOn = false;
  }

  Activity getActivitiesByStravaId(String? stravaId) =>
      activities!.where((activity) {
        if (activity.stravaId == stravaId) {
          return true;
        }

        return false;
      }).first;

  bool stravaLogout() {
    activities!.removeWhere((activity) =>
        activity.status == ActivityStatus.nodonate ? true : false);

    return true;
  }

  bool hasTerms() => isTermsOn;
}
