import 'package:yodravet/src/model/feed.dart';

abstract class FeedDaoInterface {
  Stream<List<Feed>> streamFeed(String raceId, Feed? afterDocument, int limit);
}
