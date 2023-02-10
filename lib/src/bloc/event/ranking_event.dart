abstract class RankingEvent{
}

class RankingEventEmpty extends RankingEvent{
  @override
  String toString() => 'Empty Event';
}

class LoadInitialDataEvent extends RankingEvent{
  @override
  String toString() => 'LoadInitialData Event';
}

class UploadRankingFieldsEvent extends RankingEvent {
  @override
  String toString() => 'UploadRankingFields Event';
}

class ChangeRankingPodiumTabEvent extends RankingEvent {
  final int indexTab;

  ChangeRankingPodiumTabEvent(this.indexTab);
  @override
  String toString() => 'ChangeRankingPodiumTab Event';
}