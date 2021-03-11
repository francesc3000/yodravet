import 'package:yodravet/src/repository/firestore_repository_impl.dart';
import 'package:yodravet/src/routes/navigation_service.dart';

import 'race_dao_impl.dart';
import 'user_dao_impl.dart';

class FactoryDao {
  static const String MOCK = 'Mock';
  final FirestoreRepositoryImpl _firestore = FirestoreRepositoryImpl();

  final NavigationService navigationService = NavigationService();
  UserDaoImpl userDao;
  RaceDaoImpl raceDao;

  FactoryDao(){
    userDao = UserDaoImpl(_firestore);
    raceDao = RaceDaoImpl(_firestore);
  }


}
