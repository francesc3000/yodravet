import 'package:rive/rive.dart';

class RaceMapFactory {
  Artboard? riveArtboardSpain;
  Artboard? riveArtboardArgentina;
  int? _stage;

  Map<int, Map<int, int>> spainLinkStageStep = {
    1: {1: 1},
    2: {1: 3},
    3: {1: 2},
    4: {4: 6},
    5: {1: 3},
    6: {1: 2},
    7: {1: 1},
    8: {1: 1},
    9: {1: 1},
    10: {1: 0}
  };

  Map<int, Map<int, int>> argentinaLinkStageStep = {
    1: {1: 0},
    2: {1: 0},
    3: {3: 4},
    4: {1: 3},
    5: {1: 0},
    6: {1: 0},
    7: {1: 0},
    8: {1: 0},
    9: {1: 0},
    10: {1: 0}
  };

  bool get isArgentinaActive4AutoChange => _stage == null
      ? false
      : _stage! >= 3
          ? true
          : false;

  bool get isSpainActive4AutoChange => _stage == null
      ? false
      : _stage! >= 4
          ? true
          : false;

  Future<void> init(
      int stage, DateTime startStageDate, DateTime nextStageDate) async {
    _stage = stage;
    RiveFile riveFileSpain =
        await RiveFile.asset('assets/images/race/spain.riv');
    riveArtboardSpain = riveFileSpain.mainArtboard;

    RiveFile riveFileArgentina =
        await RiveFile.asset('assets/images/race/argentina.riv');
    riveArtboardArgentina = riveFileArgentina.mainArtboard;

    _buildControllers(
      riveArtboardArgentina,
      argentinaLinkStageStep,
      stage,
      startStageDate,
      nextStageDate,
    );

    _buildControllers(
      riveArtboardSpain,
      spainLinkStageStep,
      stage,
      startStageDate,
      nextStageDate,
    );

    MySimpleAnimation controllerShark;
    var sharkController = 'Shark';
    controllerShark = MySimpleAnimation(sharkController);
    controllerShark.isActive = true;
    riveArtboardSpain!.addController(controllerShark);
  }
}

void _buildControllers(
    Artboard? riveArtboardSpain,
    Map<int, Map<int, int>> linkStageStep,
    int stage,
    DateTime startStageDate,
    DateTime nextStageDate) {
  RiveAnimationController? firstControllerStep;
  MySimpleAnimation? preControllerStep;
  MySimpleAnimation controllerStep;
  bool first = false;
  // int _stage = -1;

  // if (_stage != stage) {
  //   _stage = stage;
  //   _first = false;
  // } else {
  //   return;
  // }

  for (int i = 1; i <= stage; i++) {
    final today = DateTime.now();
    int startStep = linkStageStep[i]!.keys.first;
    int step = 0;
    if (today.isAtSameMomentAs(startStageDate) ||
        today.isAfter(startStageDate)) {
      if (i == stage && today.isBefore(nextStageDate)) {
        var diffDays = nextStageDate.difference(today).inDays;
        step = linkStageStep[stage]!.values.first - diffDays;
        step = step.abs();
      } else {
        step = linkStageStep[i]!.values.first;
      }
    }
    for (int j = startStep; j <= step; j++) {
      var controllerName = 'Stage$i Step$j';
      controllerStep = MySimpleAnimation(controllerName);

      if (!first) {
        first = true;
        firstControllerStep = controllerStep;
      }

      if (preControllerStep != null) {
        preControllerStep.nextAnimation = controllerStep;
        riveArtboardSpain!.addController(preControllerStep);
        preControllerStep.isActive = false;
      }
      preControllerStep = controllerStep;
    }
  }

  if (preControllerStep != null) {
    riveArtboardSpain!.addController(preControllerStep);
    preControllerStep.isActive = false;
  }

  if (firstControllerStep != null) {
    firstControllerStep.isActive = true;
  }
}

class MySimpleAnimation extends SimpleAnimation {
  RiveAnimationController? nextAnimation;

  MySimpleAnimation(String name, {this.nextAnimation}) : super(name);

  @override
  void onDeactivate() {
    if (nextAnimation != null) {
      nextAnimation!.isActive = true;
    }
  }
}
