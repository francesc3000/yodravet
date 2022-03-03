import 'dart:async';

import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/repository/firestore_repository_impl.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/race_dao_interface.dart';

class RaceDaoImpl extends RaceDaoInterface {
  final FirestoreRepositoryImpl firestore;

  RaceDaoImpl(this.firestore);

  @override
  Stream<Race> streamRaceInfo(String raceId) =>
      firestore.streamRaceInfo(raceId)!.transform<Race>(
        StreamTransformer<RaceDao, Race>.fromHandlers(
            handleData: (raceDao, sink) {
          sink.add(TransformModel.raceDao2Race(raceDao));
        }),
      );

  @override
  Stream<List<ActivityPurchase>> streamBuyers(String raceId) =>
      firestore.streamBuyers(raceId)!.transform<List<ActivityPurchase>>(
        StreamTransformer<List<ActivityPurchaseDao>,
                List<ActivityPurchase>>.fromHandlers(
            handleData: (activitiesPurchaseDao, sink) {
          sink.add(TransformModel.activitiesPurchaseDao2ActivitiesPurchase(
              activitiesPurchaseDao));
        }),
      );

  @override
  Stream<List<ActivityPurchase>> streamDonors(String raceId) =>
      firestore.streamDonors(raceId)!.transform<List<ActivityPurchase>>(
        StreamTransformer<List<ActivityPurchaseDao>,
                List<ActivityPurchase>>.fromHandlers(
            handleData: (activitiesPurchaseDao, sink) {
          sink.add(TransformModel.activitiesPurchaseDao2ActivitiesPurchase(
              activitiesPurchaseDao));
        }),
      );
}
