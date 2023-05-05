import 'activity_dao.dart';

class UserDao {
  String? id;
  String? email;
  String? name;
  String? lastname;
  String? photo;
  String? teamId;
  List<ActivityDao>? activitiesDao;
  bool? isStravaLogin;
  bool? isTermsOn;

  UserDao(
      {this.id = '',
      this.email = '',
      this.name = '',
      this.lastname = '',
      this.photo = '',
      this.isStravaLogin = false,
        this.teamId,
        this.isTermsOn = false,
      this.activitiesDao}) {
        activitiesDao ??= [];
      }
}
