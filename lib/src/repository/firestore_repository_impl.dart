import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_dao.dart';
import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/buyer_dao.dart';
import 'package:yodravet/src/model/collaborator_dao.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/race_spot_dato.dart';
import 'package:yodravet/src/model/ranking_dao.dart';
import 'package:yodravet/src/model/team_dao.dart';
import 'package:yodravet/src/model/user_dao.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/repository.dart';

class FirestoreRepositoryImpl implements Repository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  CollectionReference<Map<String, dynamic>> get userCollectionEndpoint =>
      _firestore.collection('users');

  @override
  CollectionReference<Map<String, dynamic>> get raceCollectionEndpoint =>
      _firestore.collection('races');

  @override
  CollectionReference<Map<String, dynamic>> get teamCollectionEndpoint =>
      _firestore.collection('teams');

  @override
  CollectionReference<Map<String, dynamic>>
      get collaboratorCollectionEndpoint => _firestore.collection('sponsors');

  @override
  Future<UserDao> getUserById(String? userId, String raceId) async {
    UserDao userDao = UserDao();
    DocumentSnapshot snapshot = await userCollectionEndpoint.doc(userId).get();
    if (snapshot.exists) {
      List<ActivityDao> activitiesDao = [];
      Map data = snapshot.data() as Map;

      //Se buscan las actividades del usuario
      QuerySnapshot queryActivites = await userCollectionEndpoint
          .doc(userId)
          .collection('activities')
          .where("raceId", isEqualTo: raceId)
          .get();

      if (queryActivites.docs.isNotEmpty) {
        activitiesDao.addAll(queryActivites.docs
            .map<ActivityDao>((QueryDocumentSnapshot snapshot) {
          Map data = snapshot.data() as Map;
          return TransformModel.raw2ActivityDao(
            id: snapshot.id,
            stravaId: data['stravaId'],
            raceId: data['raceId'],
            distance: double.parse(data['distance'].toString()),
            startDate: data['date'].toDate(),
            isDonate: data['isDonate'],
            isPurchase: data['isPurchase'],
            totalPurchase: double.parse(data['totalPurchase'].toString()),
            type: data['type'],
          );
        }).toList());
      }

      userDao = TransformModel.raw2UserDao(
        id: userId,
        email: data['email'],
        name: data['name'],
        lastname: data['lastname'],
        photo: data['photo'],
        isStravaLogin: data['isStravaLogin'],
        teamId: data['teamId'],
        activitiesDao: activitiesDao,
      );
    }

    return userDao;
  }

  @override
  Future<bool> createUser(
      {String? id,
      String? email,
      String? name,
      String? lastname,
      String? photo}) async {
    await userCollectionEndpoint.doc(id).set({
      'email': email,
      'name': name,
      'lastname': lastname,
      'photo': photo,
      'isStravaLogin': false,
    });

    return true;
  }

  @override
  Future<bool> donateKm(
          String? userId,
          String userFullname,
          String raceId,
          String? teamId,
          String? userStravaId,
          String? userPhoto,
          DateTime? userRaceDate,
          double? distance,
          bool userRaceIsDonate,
          bool userRaceIsPurchase,
          double? totalPurchase,
          String activityType) async =>
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // se recupera el contador global, km extras y la información de las
        // etapas (stages)
        //LECTURAS
        DocumentSnapshot raceSnapshot =
            await transaction.get(raceCollectionEndpoint.doc(raceId));

        DocumentSnapshot userRankingSnapshot = await transaction.get(
            raceCollectionEndpoint
                .doc(raceId)
                .collection('ranking')
                .doc(userId));

        DocumentSnapshot teamRankingSnapshot = await transaction.get(
            raceCollectionEndpoint
                .doc(raceId)
                .collection('ranking')
                .doc(teamId));

        DocumentSnapshot? teamSnapshot;
        if (teamId != null) {
          teamSnapshot =
              await transaction.get(_firestore.collection('teams').doc(teamId));
        }

        //CALCULOS Y ACTUALIZACIONES
        if (raceSnapshot.exists) {
          Map? data = raceSnapshot.data() as Map;

          double counter = double.parse(data['counter'].toString());
          double extraCounter = double.parse(data['extraCounter'].toString());
          double stageCounter = double.parse(data['stageCounter'].toString());
          double stageLimit = double.parse(data['stageLimit'].toString());

          for (int i = 0; i < distance!; i++) {
            // se guardan los km globales
            counter = counter + 1;
            if (stageCounter < stageLimit) {
              // se guardan los km diarios en la fecha
              stageCounter = stageCounter + 1;
            } else {
              // si se superan los km diarios se guardan en contador km extras
              extraCounter = extraCounter + 1;
            }
          }

          // se guardan los datos actualizados
          transaction.update(raceCollectionEndpoint.doc(raceId), {
            'counter': counter,
            'stageCounter': stageCounter,
            'extraCounter': extraCounter,
          });

          if (userRankingSnapshot.exists) {
            Map? data = userRankingSnapshot.data() as Map;
            var distanceDB = data[activityType] ?? 0;

            double distance4Save =
                distance + double.parse(distanceDB.toString());

            // se actualiza el ranking del usuario
            transaction.update(
                raceCollectionEndpoint
                    .doc(raceId)
                    .collection('ranking')
                    .doc(userId),
                {
                  activityType: distance4Save,
                });
          } else {
            transaction.set(
                raceCollectionEndpoint
                    .doc(raceId)
                    .collection('ranking')
                    .doc(userId),
                {
                  activityType: distance,
                  'userFullname': userFullname,
                  'userPhoto': userPhoto,
                  'isTeam': false,
                });
          }
          if (teamId != null) {
            // se actualiza el ranking del equipo del usuario
            if (teamRankingSnapshot.exists) {
              Map? data = teamRankingSnapshot.data() as Map;
              var distanceDB = data[activityType] ?? 0;

              double distance4Save =
                  distance + double.parse(distanceDB.toString());

              // se actualiza el ranking del usuario
              transaction.update(
                  raceCollectionEndpoint
                      .doc(raceId)
                      .collection('ranking')
                      .doc(teamId),
                  {
                    activityType: distance4Save,
                  });
            } else {
              if (teamSnapshot!.exists) {
                Map? dataTeam = teamSnapshot.data() as Map;
                String teamFullname = dataTeam['fullname'];
                String teamPhoto = dataTeam['photo'];
                transaction.set(
                    // raceCollectionEndpoint
                    _firestore
                        .collection('races')
                        .doc(raceId)
                        .collection('ranking')
                        .doc(teamId),
                    {
                      activityType: distance,
                      'userFullname': teamFullname,
                      'userPhoto': teamPhoto,
                      'isTeam': true,
                    });
              }
            }
          }

          // se guarda la actividad en el pool de la carrera
          var _randomId =
              raceCollectionEndpoint.doc(raceId).collection('pool').doc().id;
          transaction.set(
              raceCollectionEndpoint
                  .doc(raceId)
                  .collection('pool')
                  .doc(_randomId),
              {
                'userId': userId,
                'userFullname': userFullname,
                'userPhoto': userPhoto,
                'date': Timestamp.fromDate(userRaceDate!),
                'distance': distance,
                'isDonate': userRaceIsDonate,
                'isPurchase': userRaceIsPurchase,
                'totalPurchase': totalPurchase,
                'type': activityType,
              });

          // se guarda la actividad al usuario
          transaction.set(
              userCollectionEndpoint
                  .doc(userId)
                  .collection('activities')
                  .doc(_randomId),
              {
                'stravaId': userStravaId,
                'raceId': raceId,
                'date': Timestamp.fromDate(userRaceDate),
                'distance': distance,
                'isDonate': userRaceIsDonate,
                'isPurchase': userRaceIsPurchase,
                'totalPurchase': totalPurchase,
                'type': activityType,
              });
        }

        return true;
      });

  @override
  Future<bool> saveIsStravaLogin(String? userId, bool? isStravaLogin) async {
    await userCollectionEndpoint
        .doc(userId)
        .update({'isStravaLogin': isStravaLogin});
    return true;
  }

  @override
  Stream<RaceDao?> streamRaceInfo(String raceId) =>
      raceCollectionEndpoint.doc(raceId).snapshots().transform<RaceDao?>(
        StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
            RaceDao?>.fromHandlers(handleData: (snapshot, sink) {
          RaceDao? raceDao;

          if (snapshot.exists) {
            Map? data = snapshot.data();
            if (data != null) {
              raceDao = TransformModel.raw2RaceDao(
                  double.parse(data['counter'].toString()),
                  double.parse(data['stageCounter'].toString()),
                  double.parse(data['extraCounter'].toString()),
                  data['stage'],
                  double.parse(data['stageLimit'].toString()),
                  data['stageTitle'],
                  data['nextStageDate'].toDate(),
                  data['startDate'].toDate(),
                  data['finalDate'].toDate(),
                  data['purchaseButterfliesSite'],
                  data['purchaseSongSite']);
            }
          }

          sink.add(raceDao);
        }),
      );

  @override
  Stream<List<BuyerDao>> streamBuyers(String raceId) => raceCollectionEndpoint
          .doc(raceId)
          .collection('butterflies')
          .snapshots()
          .transform<List<BuyerDao>>(
        StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
            List<BuyerDao>>.fromHandlers(handleData: (query, sink) {
          List<BuyerDao> buyers = [];

          if (query.docs.isNotEmpty) {
            buyers = query.docs.map<BuyerDao>((snapshot) {
              Map data = snapshot.data();
              return TransformModel.raw2BuyerDao(
                  id: snapshot.id,
                  date: data['date'].toDate(),
                  butterfly: double.parse(data['butterfly'].toString()),
                  totalPurchase: double.parse(data['totalPurchase'].toString()),
                  userId: data['userId'],
                  userFullname: data['userFullname'],
                  userPhoto: data['userPhoto']);
            }).toList();
          }
          sink.add(buyers);
        }),
      );

  @override
  Stream<List<ActivityPurchaseDao>> streamDonors(
          String raceId, String userId) =>
      raceCollectionEndpoint
          .doc(raceId)
          .collection('pool')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .transform<List<ActivityPurchaseDao>>(
        StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
            List<ActivityPurchaseDao>>.fromHandlers(handleData: (query, sink) {
          List<ActivityPurchaseDao> doners = [];

          if (query.docs.isNotEmpty) {
            doners = query.docs.map<ActivityPurchaseDao>((snapshot) {
              Map data = snapshot.data();
              return TransformModel.raw2ActivityPurchaseDao(
                  id: snapshot.id,
                  raceId: raceId,
                  startDate: data['date'].toDate(),
                  distance: double.parse(data['distance'].toString()),
                  totalPurchase: double.parse(data['totalPurchase'].toString()),
                  userId: data['userId'],
                  userFullname: data['userFullname'],
                  userPhoto: data['userPhoto'],
                  type: data['type']);
            }).toList();
          }
          sink.add(doners);
        }),
      );

  @override
  Stream<List<RankingDao>> streamRanking(String raceId) =>
      raceCollectionEndpoint
          .doc(raceId)
          .collection('ranking')
          .snapshots()
          .transform<List<RankingDao>>(
        StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
            List<RankingDao>>.fromHandlers(handleData: (query, sink) {
          List<RankingDao> ranking = [];

          if (query.docs.isNotEmpty) {
            ranking = query.docs.map<RankingDao>((snapshot) {
              Map? data = snapshot.data();
              return TransformModel.raw2RankingDao(
                  id: snapshot.id,
                  run: data[ActivityType.run.getString]?.toString(),
                  walk: data[ActivityType.walk.getString]?.toString(),
                  ride: data[ActivityType.ride.getString]?.toString(),
                  isTeam: data['isTeam'],
                  userFullname: data['userFullname'],
                  userPhoto: data['userPhoto']);
            }).toList();
          }
          sink.add(ranking);
        }),
      );

  @override
  Future<List<CollaboratorDao>> getCollaborators() async {
    List<CollaboratorDao> collaboratorsDao = [];

    QuerySnapshot queryCollaborators =
        await _firestore.collection("sponsors").get();

    if (queryCollaborators.docs.isNotEmpty) {
      collaboratorsDao =
          queryCollaborators.docs.map<CollaboratorDao>((snapshot) {
        Map data = snapshot.data() as Map;

        return TransformModel.raw2CollaboratorDao(
          id: snapshot.id,
          name: data['name'],
          logoPath: data['logoPath'],
          website: data['website'],
          type: data['type'],
        );
      }).toList();
    }

    return collaboratorsDao;
  }

  @override
  Stream<List<TeamDao>?> streamTeams() => teamCollectionEndpoint
          .where("delete", isEqualTo: false)
          .snapshots()
          .transform<List<TeamDao>?>(
        StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
            List<TeamDao>?>.fromHandlers(handleData: (query, sink) {
          List<TeamDao>? teams;

          if (query.docs.isNotEmpty) {
            teams = query.docs.map<TeamDao>((snapshot) {
              Map? data = snapshot.data();
              return TransformModel.raw2TeamDao(
                  id: snapshot.id,
                  userId: data['userId'],
                  fullname: data['fullname'],
                  photo: data['photo'],
                  delete: data['delete']);
            }).toList();
          }
          sink.add(teams);
        }),
      );

  @override
  Future<bool> changeUserTeam(String mode, String userId, String teamId) async {
    if (mode == 'J') {
      //Join
      await _firestore.collection("users").doc(userId).update({
        'teamId': teamId,
      });
    } else {
      await _firestore.collection("users").doc(userId).update({
        'teamId': null,
      });
    }

    return Future.value(true);
  }

  @override
  Stream<List<RaceSpotDao>> streamRaceSpot(String raceId) =>
      raceCollectionEndpoint
          .doc(raceId)
          .collection("spots")
          .snapshots()
          .transform<List<RaceSpotDao>>(
        StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
            List<RaceSpotDao>>.fromHandlers(handleData: (query, sink) {
          List<RaceSpotDao> raceSpots = [];

          if (query.docs.isNotEmpty) {
            raceSpots = query.docs.map<RaceSpotDao>((snapshot) {
              Map? data = snapshot.data();
              return TransformModel.raw2RaceSpotDao(
                  id: snapshot.id, vote: data['vote']?.toString());
            }).toList();
          }
          sink.add(raceSpots);
        }),
      );
}
