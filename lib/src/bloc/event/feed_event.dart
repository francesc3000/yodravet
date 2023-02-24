abstract class FeedEvent{
}

class FeedEventEmpty extends FeedEvent{
  @override
  String toString() => 'Empty Event';
}

class LoadInitialDataEvent extends FeedEvent{
  @override
  String toString() => 'LoadInitialData Event';
}

class FetchNextPageEvent extends FeedEvent{
  final double maxScroll;
  final double currentScroll;
  final double height;

  FetchNextPageEvent(this.maxScroll, this.currentScroll, this.height);
  @override
  String toString() => 'FetchNextPage Event';
}

class UploadFeedFieldsEvent extends FeedEvent {
  @override
  String toString() => 'UploadFeedFields Event';
}