import 'package:yodravet/src/model/collaborator.dart';

abstract class CollaboratorDaoInterface {
  Future<List<Collaborator>> getCollaborators();
}
