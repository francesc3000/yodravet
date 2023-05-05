import 'package:rive/rive.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/race_spot.dart';
import 'package:yodravet/src/model/spot.dart';

abstract class RaceState {}

class RaceInitState extends RaceState {
  @override
  String toString() => 'RaceInitState';
}

class UpdateRaceFieldsState extends RaceState {
  final double kmCounter;
  final double stageCounter;
  final double extraCounter;
  final double stageLimit;
  final String stageTitle;
  final double stageDayLeft;
  final Artboard? riveArtboardSpain;
  final Artboard? riveArtboardArgentina;
  final List<Buyer> buyers;
  final Spot? currentSpot;
  final Spot? currentMouseSpot;
  final List<Spot> spainStagesBuilding;
  final List<Spot> argentinaStagesBuilding;
  final List<RaceSpot> raceSpots;
  final List<String> spotVotes;
  final bool canVote;
  final bool hasVote;
  final bool isSpainMapSelected;
  final bool isRaceOver;

  UpdateRaceFieldsState(
      {required this.kmCounter,
        required this.stageCounter,
        required this.extraCounter,
        required this.stageLimit,
        required this.stageTitle,
        required this.stageDayLeft,
        required this.riveArtboardSpain,
        required this.riveArtboardArgentina,
        required this.buyers,
        required this.currentSpot,
        required this.currentMouseSpot,
        required this.spainStagesBuilding,
        required this.argentinaStagesBuilding,
        required this.raceSpots,
        required this.spotVotes,
        required this.canVote,
        required this.hasVote,
        required this.isSpainMapSelected,
        required this.isRaceOver});

  @override
  String toString() => 'UploadRaceFields State';
}

class RaceDateLoadedState extends RaceState {
  final Race race;

  RaceDateLoadedState(this.race);

  @override
  String toString() => 'RaceDateLoaded State';
}

class RaceStateError extends RaceState {
  final String message;

  RaceStateError(this.message);

  @override
  String toString() => 'RaceStateError';
}