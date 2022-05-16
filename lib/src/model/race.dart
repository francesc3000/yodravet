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
  String purchaseButterfliesSite;
  String purchaseSongSite;

  Race(
      {required this.kmCounter,
      required this.stageCounter,
      required this.extraCounter,
      required this.stage,
      required this.stageLimit,
      required this.stageTitle,
      required this.nextStageDate,
      required this.startDate,
      required this.finalDate,
      required this.purchaseButterfliesSite,
      required this.purchaseSongSite});

  bool get isOver {
    if (DateTime.now().compareTo(startDate) == -1 &&
            DateTime.now().compareTo(finalDate) == -1) {
      return true;
    }

    if (DateTime.now().compareTo(startDate) == 1 &&
        DateTime.now().compareTo(finalDate) == 1) {
      return true;
    }

    return false;
  }
}
