import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_dao.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/activity_purchase_dao.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/buyer_dao.dart';
import 'package:yodravet/src/model/collaborator.dart';
import 'package:yodravet/src/model/collaborator_dao.dart';
import 'package:yodravet/src/model/feed.dart';
import 'package:yodravet/src/model/feed_dao.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/race_dao.dart';
import 'package:yodravet/src/model/race_spot.dart';
import 'package:yodravet/src/model/race_spot_dato.dart';
import 'package:yodravet/src/model/ranking.dart';
import 'package:yodravet/src/model/ranking_dao.dart';
import 'package:yodravet/src/model/team.dart';
import 'package:yodravet/src/model/team_dao.dart';
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
          String? teamId,
            bool? isTermsOn,
          List<ActivityDao>? activitiesDao}) =>
      UserDao(
        id: id,
        photo: photo,
        email: email,
        name: name,
        lastname: lastname,
        isStravaLogin: isStravaLogin,
        teamId: teamId,
        isTermsOn: isTermsOn,
        activitiesDao: activitiesDao,
      );

  static User userDao2User(UserDao userDao) => User(
        id: userDao.id,
        email: userDao.email,
        name: userDao.name,
        lastname: userDao.lastname,
        photo: userDao.photo,
        isStravaLogin: userDao.isStravaLogin,
        teamId: userDao.teamId,
        isTermsOn: userDao.isTermsOn ?? false,
        activities:
            TransformModel.activitiesDao2Activities(userDao.activitiesDao!),
      );

  static raw2ActivityDao(
          {String? id,
          String? stravaId,
          String? raceId,
          String? teamId,
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
      finalDate: raceDao.finalDate,
      purchaseButterfliesSite: raceDao.purchaseButterfliesSite,
      purchaseSongSite: raceDao.purchaseSongSite);

  static RaceDao raw2RaceDao(
          double kmCounter,
          double stageCounter,
          double extraCounter,
          int stage,
          double stageLimit,
          String stageTitle,
          DateTime nextStageDate,
          DateTime startDate,
          DateTime finalDate,
          String purchaseButterfliesSite,
          String purchaseSongSite) =>
      RaceDao(
          kmCounter: kmCounter,
          stageCounter: stageCounter,
          extraCounter: extraCounter,
          stage: stage,
          stageLimit: stageLimit,
          stageTitle: stageTitle,
          nextStageDate: nextStageDate,
          startDate: startDate,
          finalDate: finalDate,
          purchaseButterfliesSite: purchaseButterfliesSite,
          purchaseSongSite: purchaseSongSite);

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

  static CollaboratorDao raw2CollaboratorDao(
          {required String id,
          required name,
          required logoPath,
          required website,
          required type}) =>
      CollaboratorDao(
          id: id, name: name, logoPath: logoPath, website: website, type: type);

  static List<Collaborator> collaboratorsDao2Collaborators(
          List<CollaboratorDao> collaboratorsDao) =>
      collaboratorsDao.map(collaboratorDao2Collaborator).toList();

  static Collaborator collaboratorDao2Collaborator(
      CollaboratorDao collaboratorDao) {
    CollaboratorType type = CollaboratorType.values.firstWhere(
        (e) => e.toString() == "CollaboratorType.${collaboratorDao.type}");
    return Collaborator(
      id: collaboratorDao.id,
      name: collaboratorDao.name,
      logoPath: collaboratorDao.logoPath,
      website: collaboratorDao.website,
      type: type,
    );
  }

  static RankingDao raw2RankingDao(
          {required String id,
          String? run,
          String? walk,
          String? ride,
          required bool isTeam,
          required String userFullname,
          required String userPhoto}) =>
      RankingDao(id, run, walk, ride, isTeam, userFullname, userPhoto);

  static Ranking rankingDao2Ranking(RankingDao rankingDao) => Ranking(
      rankingDao.id,
      rankingDao.run != null ? double.parse(rankingDao.run!) : null,
      rankingDao.walk != null ? double.parse(rankingDao.walk!) : null,
      rankingDao.ride != null ? double.parse(rankingDao.ride!) : null,
      rankingDao.isTeam,
      rankingDao.userFullname,
      rankingDao.userPhoto);

  static List<Ranking> rankingsDao2Rankings(List<RankingDao> rankingsDao) =>
      rankingsDao.map(rankingDao2Ranking).toList();

  static TeamDao raw2TeamDao(
          {required String id,
          required String fullname,
          required String photo,
          required bool delete}) =>
      TeamDao(id, fullname, photo, delete);

  static List<Team>? teamsDao2Teams(List<TeamDao>? teamsDao) =>
      teamsDao?.map(teamDao2Team).toList();

  static Team teamDao2Team(TeamDao teamDao) => Team(teamDao.id,
      teamDao.fullname, teamDao.photo, teamDao.delete);

  static List<RaceSpot> raceSpotsDao2RaceSpots(List<RaceSpotDao> raceSpotDao) =>
      raceSpotDao.map(raceSpotDao2RaceSpot).toList();

  static RaceSpot raceSpotDao2RaceSpot(RaceSpotDao raceSpotDao) =>
      RaceSpot(raceSpotDao.id, raceSpotDao.vote);

  static RaceSpotDao raw2RaceSpotDao(
          {required String id, required String? vote}) =>
      RaceSpotDao(id, vote == null ? 0 : int.parse(vote));

  static List<Feed> feedsDao2Feeds(List<FeedDao> feedsDao) =>
      feedsDao.map(feedDao2Feed).toList();

  static Feed feedDao2Feed(FeedDao feedDao) =>
      Feed(feedDao.id, feedDao.dateTime, feedDao.message);

  static FeedDao raw2FeedDao(
          {required String id,
          required Timestamp dateTime,
          required message}) =>
      FeedDao(id, dateTime.toDate(), message);

  static FeedDao? feed2FeedDao(Feed feed) =>
      FeedDao(feed.id, feed.dateTime, feed.message);
}
