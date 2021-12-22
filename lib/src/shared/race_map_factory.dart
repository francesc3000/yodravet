import 'package:flutter/services.dart' show rootBundle;
import 'package:rive/rive.dart';

class RaceMapFactory {
  Artboard riveArtboard;
  bool _first = false;
  int _stage = -1;
  RiveAnimationController _firstControllerStep;
  // RiveAnimationController _controllerStep1b;

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

  Future init(int stage, DateTime startStageDate, DateTime nextStageDate) async {
    
    if (_stage!=stage) {
      _stage = stage;
      _first = false;
    } else {
      return;
    }

    var data = await rootBundle.load('assets/race/spain.riv');
    final file = RiveFile();

    // Load the RiveFile from the binary data.
    if (file.import(data)) {
      // The artboard is the root of the animation and gets drawn in the
      // Rive widget.
      riveArtboard = file.mainArtboard;
      
      MySimpleAnimation _preControllerStep;
      MySimpleAnimation _controllerStep;
      int i;
      for (i = 1; i <= stage; i++) {
        final today = DateTime.now();
        int step = 0;
        if (today.isAtSameMomentAs(startStageDate) ||  today.isAfter(startStageDate)) {
          if (i == stage && today.isBefore(nextStageDate)) {
            var diffDays = nextStageDate.difference(today).inDays;
            step = linkStageStep[stage] - diffDays;
            step = step.abs();
          } else {
            step = linkStageStep[i];
          }
        }
        for (int j = 1; j <= step; j++) {
          var controllerName = 'Stage' + '$i' + ' Step' + '$j';
          _controllerStep = MySimpleAnimation(controllerName);

          if (!_first) {
            _first = true;
            _firstControllerStep = _controllerStep;
          }

          if (_preControllerStep != null) {
            _preControllerStep.nextAnimation = _controllerStep;
            riveArtboard.addController(_preControllerStep);
            _preControllerStep.isActive = false;
          }
          _preControllerStep = _controllerStep;
        }
      }

      if (_preControllerStep != null) {
        riveArtboard.addController(_preControllerStep);
        _preControllerStep.isActive = false;

        // var controllerName = 'Stage' + '$i' + ' Glow';
        // _controllerStep = MySimpleAnimation(controllerName);
        // _preControllerStep.nextAnimation = _controllerStep;

        // riveArtboard.addController(_controllerStep);
        // _controllerStep.isActive = false;
      }

      if (_firstControllerStep != null) {
        _firstControllerStep.isActive = true;
      }

      // _riveArtboard.animationByName('Stage1 Building').animation.loop = Loop.loop;
      // _riveArtboard.animationByName('Stage1 Building').animation.duration = 11500;

    }
  }
}

class MySimpleAnimation extends SimpleAnimation {
  RiveAnimationController nextAnimation;

  MySimpleAnimation(String name, {this.nextAnimation}) : super(name);

  @override
  void onDeactivate() {
    if (nextAnimation != null) {
      nextAnimation.isActive = true;
    }
  }
}
