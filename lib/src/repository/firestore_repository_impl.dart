import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yodravet/src/model/activity_dao.dart';
import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/buyer_dao.dart';
import 'package:yodravet/src/model/collaborator_dao.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/user_dao.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/repository.dart';

class FirestoreRepositoryImpl implements Repository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  get userCollectionEndpoint => _firestore.collection('users');

  @override
  get raceCollectionEndpoint => _firestore.collection('races');

  @override
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
        DocumentSnapshot raceSnapshot =
            await transaction.get(raceCollectionEndpoint.doc(raceId));
        if (raceSnapshot.exists) {
          Map data = raceSnapshot.data() as Map;

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
                  data['finalDate'].toDate());
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
  Stream<List<ActivityPurchaseDao>>? streamDonors(String raceId) =>
      raceCollectionEndpoint
          .doc(raceId)
          .collection('pool')
          .where('isDonate', isEqualTo: true)
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
}
