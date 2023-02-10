import 'dart:async';

import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/buyer_dao.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/race_spot.dart';
import 'package:yodravet/src/model/race_spot_dato.dart';
import 'package:yodravet/src/model/ranking.dart';
import 'package:yodravet/src/model/ranking_dao.dart';
import 'package:yodravet/src/repository/firestore_repository_impl.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/race_dao_interface.dart';

class RaceDaoImpl extends RaceDaoInterface {
  final FirestoreRepositoryImpl firestore;

  RaceDaoImpl(this.firestore);

  @override
  Stream<Race?> streamRaceInfo(String raceId) =>
      firestore.streamRaceInfo(raceId).transform<Race?>(
        StreamTransformer<RaceDao?, Race?>.fromHandlers(
            handleData: (raceDao, sink) {
          sink.add(
              raceDao == null ? null : TransformModel.raceDao2Race(raceDao));
        }),
      );

  @override
  Stream<List<Buyer>> streamBuyers(String raceId) =>
      firestore.streamBuyers(raceId).transform<List<Buyer>>(
        StreamTransformer<List<BuyerDao>, List<Buyer>>.fromHandlers(
            handleData: (buyersDao, sink) {
          sink.add(TransformModel.buyersDao2Buyers(buyersDao));
        }),
      );

  @override
  Stream<List<ActivityPurchase>> streamDonors(String raceId, String userId) =>
      firestore.streamDonors(raceId, userId).transform<List<ActivityPurchase>>(
        StreamTransformer<List<ActivityPurchaseDao>,
                List<ActivityPurchase>>.fromHandlers(
            handleData: (activitiesPurchaseDao, sink) {
          sink.add(TransformModel.activitiesPurchaseDao2ActivitiesPurchase(
              activitiesPurchaseDao));
        }),
      );

  @override
  Stream<List<Ranking>> streamRanking(String raceId) =>
      firestore.streamRanking(raceId).transform<List<Ranking>>(
        StreamTransformer<List<RankingDao>, List<Ranking>>.fromHandlers(
            handleData: (rankingDao, sink) {
          sink.add(TransformModel.rankingsDao2Rankings(rankingDao));
        }),
      );

  @override
  Stream<List<RaceSpot>> streamRaceSpot(String raceId) =>
      firestore.streamRaceSpot(raceId).transform<List<RaceSpot>>(
        StreamTransformer<List<RaceSpotDao>, List<RaceSpot>>.fromHandlers(
            handleData: (raceSpotDao, sink) {
          sink.add(TransformModel.raceSpotsDao2RaceSpots(raceSpotDao));
        }),
      );
}
