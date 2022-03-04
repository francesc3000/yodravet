import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_dao.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/buyer_dao.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/model/user_dao.dart';

class TransformModel {
  static UserDao raw2UserDao(
          {String? id,
          String? email,
          String? photo,
          String? name,
          String? lastname,
          bool? isStravaLogin,
          List<ActivityDao>? activitiesDao}) =>
      UserDao(
        id: id,
        photo: photo,
        email: email,
        name: name,
        lastname: lastname,
        isStravaLogin: isStravaLogin,
        activitiesDao: activitiesDao,
      );

  static User userDao2User(UserDao userDao) => User(
        id: userDao.id,
        email: userDao.email,
        name: userDao.name,
        lastname: userDao.lastname,
        photo: userDao.photo,
        isStravaLogin: userDao.isStravaLogin,
        activities:
            TransformModel.activitiesDao2Activities(userDao.activitiesDao!),
      );

  static raw2ActivityDao(
          {String? id,
          String? stravaId,
          String? raceId,
          DateTime? startDate,
          double? distance,
          bool? isDonate = false,
          bool? isPurchase = false,
          double totalPurchase = 0.0,
          String? type = 'Run',
          bool isManual = false}) =>
      ActivityDao(
        id: id,
        stravaId: stravaId,
        raceId: raceId,
        startDate: startDate,
        distance: distance,
        status: isManual
            ? ActivityStatus.manual
            : isPurchase!
                ? ActivityStatus.purchase
                : isDonate!
                    ? ActivityStatus.donate
                    : ActivityStatus.nodonate,
        totalPurchase: totalPurchase,
        type: type == 'Walk'
            ? ActivityType.walk
            : type == 'Ride'
                ? ActivityType.ride
                : ActivityType.run,
      );

  static Activity activityDao2Activity(ActivityDao activityDao) => Activity(
        id: activityDao.id,
        stravaId: activityDao.stravaId,
        raceId: activityDao.raceId,
        distance: activityDao.distance,
        startDate: activityDao.startDate,
        status: activityDao.status,
        totalPurchase: activityDao.totalPurchase,
        type: activityDao.type,
      );

  static List<Activity> activitiesDao2Activities(
          List<ActivityDao> activitiesDao) =>
      activitiesDao.map(TransformModel.activityDao2Activity).toList();

  static ActivityDao activity2ActivityDao(Activity activity) => ActivityDao(
        id: activity.id,
        stravaId: activity.stravaId,
        raceId: activity.raceId,
        distance: activity.distance,
        startDate: activity.startDate,
        status: activity.status,
        totalPurchase: activity.totalPurchase,
        type: activity.type,
      );

  static Race raceDao2Race(RaceDao raceDao) => Race(
      kmCounter: raceDao.kmCounter,
      stageCounter: raceDao.stageCounter,
      extraCounter: raceDao.extraCounter,
      stage: raceDao.stage,
      stageLimit: raceDao.stageLimit,
      stageTitle: raceDao.stageTitle,
      nextStageDate: raceDao.nextStageDate,
      startDate: raceDao.startDate,
      finalDate: raceDao.finalDate);

  static RaceDao raw2RaceDao(
          double kmCounter,
          double stageCounter,
          double extraCounter,
          int stage,
          double stageLimit,
          String stageTitle,
          DateTime nextStageDate,
          DateTime startDate,
          DateTime finalDate) =>
      RaceDao(
          kmCounter: kmCounter,
          stageCounter: stageCounter,
          extraCounter: extraCounter,
          stage: stage,
          stageLimit: stageLimit,
          stageTitle: stageTitle,
          nextStageDate: nextStageDate,
          startDate: startDate,
          finalDate: finalDate);

  static ActivityPurchaseDao raw2ActivityPurchaseDao(
          {String? id,
          String? stravaId,
          String? raceId,
          DateTime? startDate,
          double? distance,
          double? totalPurchase,
          String? userId,
          String? userFullname,
          String? userPhoto,
          String? type = 'Run'}) =>
      ActivityPurchaseDao(
        id: id,
        stravaId: stravaId,
        raceId: raceId,
        startDate: startDate,
        distance: distance,
        totalPurchase: totalPurchase,
        userId: userId,
        userFullname: userFullname,
        userPhoto: userPhoto,
        type: type == 'Walk'
            ? ActivityType.walk
            : type == 'Ride'
                ? ActivityType.ride
                : ActivityType.run,
      );

  static ActivityPurchase activityPurchaseDao2ActivityPurchase(
          ActivityPurchaseDao activityPurchaseDao) =>
      ActivityPurchase(
        id: activityPurchaseDao.id,
        stravaId: activityPurchaseDao.stravaId,
        raceId: activityPurchaseDao.raceId,
        distance: activityPurchaseDao.distance,
        startDate: activityPurchaseDao.startDate,
        totalPurchase: activityPurchaseDao.totalPurchase,
        userId: activityPurchaseDao.userId,
        userFullname: activityPurchaseDao.userFullname,
        userPhoto: activityPurchaseDao.userPhoto,
        type: activityPurchaseDao.type,
      );

  static List<ActivityPurchase> activitiesPurchaseDao2ActivitiesPurchase(
          List<ActivityPurchaseDao> activitiesPurchaseDao) =>
      activitiesPurchaseDao
          .map(TransformModel.activityPurchaseDao2ActivityPurchase)
          .toList();

  static List<Buyer> buyersDao2Buyers(List<BuyerDao> buyersDao) =>
      buyersDao.map(buyerDao2Buyer).toList();

  static Buyer buyerDao2Buyer(BuyerDao buyerDao) => Buyer(
      id: buyerDao.id,
      butterfly: buyerDao.butterfly,
      date: buyerDao.date,
      totalPurchase: buyerDao.totalPurchase,
      userId: buyerDao.userId,
      userFullname: buyerDao.userFullname,
      userPhoto: buyerDao.userPhoto);

  static BuyerDao raw2BuyerDao(
          {required String id,
          required date,
          required double butterfly,
          required double totalPurchase,
          required userId,
          required userFullname,
          required userPhoto}) =>
      BuyerDao(
          id: id,
          butterfly: butterfly,
          date: date,
          totalPurchase: totalPurchase,
          userId: userId,
          userFullname: userFullname,
          userPhoto: userPhoto);
}
