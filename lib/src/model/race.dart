class Race {
  double kmCounter;
  double stageCounter;
  double extraCounter;
  int stage;
  double stageLimit;
  String stageTitle;
  DateTime nextStageDate;
  DateTime startDate;
  DateTime finalDate;

  Race(
      {required this.kmCounter,
        required this.stageCounter,
        required this.extraCounter,
        required this.stage,
        required this.stageLimit,
        required this.stageTitle,
        required this.nextStageDate,
        required this.startDate,
        required this.finalDate});

  bool get isOver => DateTime.now().compareTo(finalDate) < 0;
}
