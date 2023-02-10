import 'package:yodravet/src/model/team.dart';

abstract class TeamDaoInterface {
  Stream<List<Team>?> getTeams();
}