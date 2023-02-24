import 'package:yodravet/src/model/feed.dart';

abstract class FeedState {}

class FeedInitState extends FeedState {
  @override
  String toString() => 'FeedInitState';
}

class UploadFeedFieldsState extends FeedState {
  final List<Feed> feeds;

  UploadFeedFieldsState({ required this.feeds});
  @override
  String toString() => 'UploadFeedFields State';
}

class FeedStateError extends FeedState {
  final String message;

  FeedStateError(this.message);

  @override
  String toString() => 'FeedStateError';
}
