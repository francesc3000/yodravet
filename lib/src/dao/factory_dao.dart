import 'package:yodravet/src/repository/firestore_repository_impl.dart';

import '../route/app_router_delegate.dart';
import 'race_dao_impl.dart';
import 'user_dao_impl.dart';

class FactoryDao {
  static const String mock = 'Mock';
  final FirestoreRepositoryImpl _firestore = FirestoreRepositoryImpl();
  final AppRouterDelegate routeService;

  late UserDaoImpl userDao;
  late RaceDaoImpl raceDao;

  FactoryDao(this.routeService){
    userDao = UserDaoImpl(_firestore);
    raceDao = RaceDaoImpl(_firestore);
  }


}
