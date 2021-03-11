import 'activity.dart';

class User {
  String id;
  String email;
  String name;
  String lastname;
  String photo;
  List<Activity> activities;
  bool isStravaLogin;

  String get fullName => '$name $lastname';
  bool get isLogin => this.id.isNotEmpty;

  User(
      {this.id = '',
      this.email = '',
      this.name = '',
      this.lastname = '',
      this.photo = '',
      this.isStravaLogin = false,
      this.activities}){
        if(this.activities==null) {
          this.activities = [];
        }
      }

  void logout() {
    this.id = '';
    this.email = '';
    this.name = '';
    this.lastname = '';
    this.photo = '';
    this.activities = [];
    this.isStravaLogin = false;
  }

  Activity getActivitByStravaId(String stravaId) {
    return activities.where((activity) {
      if (activity.stravaId == stravaId) {
        return true;
      }

      return false;
    }).first;
  }

  bool stravaLogout() {
    this.activities.removeWhere((activity) => activity.status==ActivityStatus.nodonate ? true : false);

    return true;
  }
}
