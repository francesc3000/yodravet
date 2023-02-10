import 'dart:async';

import 'package:yodravet/src/model/team.dart';
import 'package:yodravet/src/model/team_dao.dart';
import 'package:yodravet/src/repository/firestore_repository_impl.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/team_dao_interface.dart';

class TeamDaoImpl extends TeamDaoInterface {
  final FirestoreRepositoryImpl firestore;

  TeamDaoImpl(this.firestore);

  @override
  Stream<List<Team>?> getTeams() =>
      firestore.streamTeams().transform<List<Team>?>(
        StreamTransformer<List<TeamDao>?,
            List<Team>?>.fromHandlers(
            handleData: (teamsDao, sink) {
              sink.add(TransformModel.teamsDao2Teams(teamsDao));
            }),
      );
}
