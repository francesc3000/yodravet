import 'activity_dao.dart';

class UserDao {
  String? id;
  String? email;
  String? name;
  String? lastname;
  String? photo;
  List<ActivityDao>? activitiesDao;
  bool? isStravaLogin;

  UserDao(
      {this.id = '',
      this.email = '',
      this.name = '',
      this.lastname = '',
      this.photo = '',
      this.isStravaLogin = false,
      this.activitiesDao}) {
        activitiesDao ??= [];
      }
}
