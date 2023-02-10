import 'package:yodravet/src/model/ranking.dart';

abstract class RankingState {}

class RankingInitState extends RankingState {
  @override
  String toString() => 'RankingInitState';
}

class UploadRankingFieldsState extends RankingState {
  final int filterRankingTab;
  final List<Ranking>? rankings;
  final List<Ranking>? rankingsTeam;
  UploadRankingFieldsState(
      this.filterRankingTab,
      this.rankings,
      this.rankingsTeam,
  );

  @override
  String toString() => 'UploadRankingFields State';
}

class RankingStateError extends RankingState {
  final String message;

  RankingStateError(this.message);

  @override
  String toString() => 'RankingStateError';
}
