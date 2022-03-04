import 'package:rive/rive.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/stage_building.dart';

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
  final Artboard riveArtboard;
  final List<Buyer> buyers;
  final StageBuilding? currentStageBuilding;
  final StageBuilding? currentMouseStageBuilding;
  final List<StageBuilding> stagesBuilding;
  final bool isSpainMapSelected;
  final bool isRaceOver;

  UpdateRaceFieldsState(
      {required this.kmCounter,
        required this.stageCounter,
        required this.extraCounter,
        required this.stageLimit,
        required this.stageTitle,
        required this.stageDayLeft,
        required this.riveArtboard,
      required this.buyers,
        required this.currentStageBuilding,
        required this.currentMouseStageBuilding,
        required this.stagesBuilding,
        required this.isSpainMapSelected,
        required this.isRaceOver});

  @override
  String toString() => 'UploadRaceFields State';
}

class RaceStateError extends RaceState {
  final String message;

  RaceStateError(this.message);

  @override
  String toString() => 'RaceStateError';
}
