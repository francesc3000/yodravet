import 'package:rive/rive.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/stage_building.dart';

abstract class RaceState {}

class RaceInitState extends RaceState {
  @override
  String toString() => 'RaceInitState';
}

class UpdateRaceFieldsState extends RaceState {
  final double? kmCounter;
  final double? stageCounter;
  final double? extraCounter;
  final double? stageLimit;
  final String? stageTitle;
  final double? stageDayLeft;
  final Artboard? riveArtboard;
  final List<ActivityPurchase>? buyers;
  final StageBuilding? currentStageBuilding;
  final StageBuilding? currentMouseStageBuilding;
  final List<StageBuilding>? stagesBuilding;
  final bool? isSpainMapSelected;

  UpdateRaceFieldsState(
      {this.kmCounter,
      this.stageCounter,
      this.extraCounter,
      this.stageLimit,
      this.stageTitle,
      this.stageDayLeft,
      this.riveArtboard,
      this.buyers,
      this.currentStageBuilding,
      this.currentMouseStageBuilding,
      this.stagesBuilding,
      this.isSpainMapSelected});

  @override
  String toString() => 'UploadRaceFields State';
}

class RaceStateError extends RaceState {
  final String message;

  RaceStateError(this.message);

  @override
  String toString() => 'RaceStateError';
}
