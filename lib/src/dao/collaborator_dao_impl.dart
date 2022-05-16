import 'package:yodravet/src/dao/interface/collaborator_dao_interface.dart';
import 'package:yodravet/src/model/collaborator.dart';
import 'package:yodravet/src/repository/firestore_repository_impl.dart';
import 'package:yodravet/src/shared/transform_model.dart';

class CollaboratorDaoImpl extends CollaboratorDaoInterface {
  final FirestoreRepositoryImpl firestore;

  CollaboratorDaoImpl(this.firestore);

  @override
  Future<List<Collaborator>> getCollaborators() async =>
      TransformModel.collaboratorsDao2Collaborators(
          await firestore.getCollaborators());
}
