import 'dart:async';

import 'package:yodravet/src/model/feed.dart';
import 'package:yodravet/src/model/feed_dao.dart';
import 'package:yodravet/src/repository/firestore_repository_impl.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/feed_dao_interface.dart';

class FeedDaoImpl extends FeedDaoInterface {
  final FirestoreRepositoryImpl firestore;

  FeedDaoImpl(this.firestore);

  @override
  Stream<List<Feed>> streamFeed(
          String raceId, Feed? afterDocument, int limit) =>
      firestore
          .streamFeed(
              raceId,
              afterDocument != null
                  ? TransformModel.feed2FeedDao(afterDocument)
                  : null,
              limit)
          .transform<List<Feed>>(
        StreamTransformer<List<FeedDao>, List<Feed>>.fromHandlers(
            handleData: (feedsDao, sink) {
          sink.add(TransformModel.feedsDao2Feeds(feedsDao));
        }),
      );
}
