import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yodravet/src/model/activity_dao.dart';
import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/user_dao.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/repository.dart';

class FirestoreRepositoryImpl implements Repository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  get userCollectionEndpoint => _firestore.collection('users');
  @override
  get raceCollectionEndpoint => _firestore.collection('races');

  @override
  Future<UserDao> getUserById(String userId) async {
    UserDao userDao = UserDao();
    DocumentSnapshot snapshot = await userCollectionEndpoint.doc(userId).get();
    if (snapshot.exists) {
      List<ActivityDao> activitiesDao = [];
      var data = snapshot.data();

      //Se buscan las actividades del usuario
      QuerySnapshot queryActivites = await userCollectionEndpoint
          .doc(userId)
          .collection('activities')
          .get();

      if (queryActivites.docs.isNotEmpty) {
        activitiesDao.addAll(queryActivites.docs
            .map<ActivityDao>((snapshot) => TransformModel.raw2ActivityDao(
                  id: snapshot.id,
                  stravaId: snapshot.data()['stravaId'],
                  raceId: snapshot.data()['raceId'],
                  distance:
                      double.parse(snapshot.data()['distance'].toString()),
                  startDate: snapshot.data()['date'].toDate(),
                  isDonate: snapshot.data()['isDonate'],
                  isPurchase: snapshot.data()['isPurchase'],
                  totalPurchase:
                      double.parse(snapshot.data()['totalPurchase'].toString()),
                  type: snapshot.data()['type'],
                ))
            .toList());
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
      {String id,
      String email,
      String name,
      String lastname,
      String photo}) async {
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
      String userId,
      String userFullname,
      String raceId,
      String userStravaId,
      String userPhoto,
      DateTime userRaceDate,
      double distance,
      bool userRaceIsDonate,
      bool userRaceIsPurchase,
      double totalPurchase,
      String activityType) async {
    // Esta l??gica deber??a existir dentro de una cloud function no aqu??

    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      // se recupera el contador global, km extras y la informaci??n de las etapas (stages)
      DocumentSnapshot raceSnapshot =
          await transaction.get(raceCollectionEndpoint.doc(raceId));
      if (raceSnapshot.exists) {
        var data = raceSnapshot.data();

        double counter = double.parse(data['counter'].toString());
        double extraCounter = double.parse(data['extraCounter'].toString());
        double stageCounter = double.parse(data['stageCounter'].toString());
        double stageLimit = double.parse(data['stageLimit'].toString());

        for (int i = 0; i < distance; i++) {
          if (stageCounter < stageLimit) {
            // se guardan los km globales
            counter = counter + 1;
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
              'date': Timestamp.fromDate(userRaceDate),
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
  }

  @override
  Future<bool> saveIsStravaLogin(String userId, bool isStravaLogin) async {
    await userCollectionEndpoint
        .doc(userId)
        .update({'isStravaLogin': isStravaLogin});
    return true;
  }

  @override
  Stream<RaceDao> streamRaceInfo(String raceId) {
    return raceCollectionEndpoint.doc(raceId).snapshots().transform<RaceDao>(
      StreamTransformer<DocumentSnapshot, RaceDao>.fromHandlers(
          handleData: (snapshot, sink) {
        RaceDao raceDao = RaceDao();

        if (snapshot.exists) {
          var data = snapshot.data();
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
  }

  @override
  Stream<List<ActivityPurchaseDao>> streamBuyers(String raceId) {
    return raceCollectionEndpoint
        .doc(raceId)
        .collection('pool')
        .where('isPurchase', isEqualTo: true)
        .snapshots()
        .transform<List<ActivityPurchaseDao>>(
      StreamTransformer<QuerySnapshot, List<ActivityPurchaseDao>>.fromHandlers(
          handleData: (query, sink) {
        List<ActivityPurchaseDao> buyers = [];

        if (query.docs.isNotEmpty) {
          buyers = query.docs.map<ActivityPurchaseDao>((snapshot) {
            var data = snapshot.data();
            return TransformModel.raw2ActivityPurchaseDao(
                id: snapshot.id,
                raceId: raceId,
                startDate: data['date'].toDate(),
                distance: double.parse(data['distance'].toString()),
                totalPurchase: double.parse(data['totalPurchase'].toString()),
                userId: data['userId'],
                userFullname: data['userFullname'],
                userPhoto: data['userPhoto']);
          }).toList();
        }
        sink.add(buyers);
      }),
    );
  }

  @override
  Stream<List<ActivityPurchaseDao>> streamDonors(String raceId) {
    return raceCollectionEndpoint
        .doc(raceId)
        .collection('pool')
        .where('isDonate', isEqualTo: true)
        .snapshots()
        .transform<List<ActivityPurchaseDao>>(
      StreamTransformer<QuerySnapshot, List<ActivityPurchaseDao>>.fromHandlers(
          handleData: (query, sink) {
        List<ActivityPurchaseDao> doners = [];

        if (query.docs.isNotEmpty) {
          doners = query.docs.map<ActivityPurchaseDao>((snapshot) {
            var data = snapshot.data();
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
  }
}
