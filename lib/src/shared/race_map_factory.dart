import 'package:rive/rive.dart';

class RaceMapFactory {
  Artboard? riveArtboard;
  bool _first = false;
  int _stage = -1;
  RiveAnimationController? _firstControllerStep;

  Map<int, int> linkStageStep = {
    1: 3,
    2: 6,
    3: 4,
    4: 5,
    5: 5,
    6: 2,
    7: 4,
    8: 2,
    9: 0
  };

  RaceMapFactory() {
    RiveFile.asset('assets/images/race/spain.riv')
        .then((file) => riveArtboard = file.mainArtboard);
  }

  Future<void> init(
      int stage, DateTime startStageDate, DateTime nextStageDate) async {
    if (_stage != stage) {
      _stage = stage;
      _first = false;
    } else {
      return;
    }

    MySimpleAnimation? _preControllerStep;
    MySimpleAnimation _controllerStep;

    for (int i = 1; i <= stage; i++) {
      final today = DateTime.now();
      int? step = 0;
      if (today.isAtSameMomentAs(startStageDate) ||
          today.isAfter(startStageDate)) {
        if (i == stage && today.isBefore(nextStageDate)) {
          var diffDays = nextStageDate.difference(today).inDays;
          step = linkStageStep[stage]! - diffDays;
          step = step.abs();
        } else {
          step = linkStageStep[i];
        }
      }
      for (int j = 1; j <= step!; j++) {
        var controllerName = 'Stage$i Step$j';
        _controllerStep = MySimpleAnimation(controllerName);

        if (!_first) {
          _first = true;
          _firstControllerStep = _controllerStep;
        }

        if (_preControllerStep != null) {
          _preControllerStep.nextAnimation = _controllerStep;
          riveArtboard!.addController(_preControllerStep);
          _preControllerStep.isActive = false;
        }
        _preControllerStep = _controllerStep;
      }
    }

    if (_preControllerStep != null) {
      riveArtboard!.addController(_preControllerStep);
      _preControllerStep.isActive = false;
    }

    if (_firstControllerStep != null) {
      _firstControllerStep!.isActive = true;
    }
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
