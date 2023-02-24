import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:yodravet/src/bloc/event/feed_event.dart';
import 'package:yodravet/src/bloc/state/feed_state.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/feed.dart';
import 'package:yodravet/src/shared/edition.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FactoryDao factoryDao;
  late List<Feed> _feeds;
  StreamSubscription? _feedSubscription;

  FeedBloc(this.factoryDao) : super(FeedInitState()) {
    on<LoadInitialDataEvent>(_loadInitialDataEvent);
    on<FetchNextPageEvent>(_fetchNextPageEvent);
    on<UploadFeedFieldsEvent>(_uploadFeedFieldsEvent);
  }

  void _loadInitialDataEvent(LoadInitialDataEvent event, Emitter emit) async {
    try {
      _streamFeeds();
    } catch (error) {
      emit(error is FeedStateError
          ? FeedStateError(error.message)
          : FeedStateError(
              'Algo fue mal al cargar los datos iniciales del usuario!'));
    }
  }

  void _streamFeeds({Feed? afterDocument}) {
    String raceId = Edition.currentEdition;
    int limit = 1000;
    _feeds = [];
    _feedSubscription = factoryDao.feedDao
        .streamFeed(raceId, afterDocument, limit)
        .listen((feeds) {
      _feeds.clear();
      for (var feed in feeds) {
        RegExp exp =
            RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.@&]+\.[\w/\-?=%.@&]+');
        Iterable<RegExpMatch> matches = exp.allMatches(feed.message);

        String message = feed.message;
        for (var match in matches) {
          String link = message.substring(match.start, match.end);
          if (feed.link == null || feed.link!.isEmpty) {
            feed.link = link;
          } else {
            feed.link = feed.link! + link;
          }

          feed.message = feed.message.replaceAll(link, "");
        }
        _feeds.add(feed);
      }

      add(UploadFeedFieldsEvent());
    });
  }

  void _fetchNextPageEvent(FetchNextPageEvent event, Emitter emit) async {
    try {
      double maxScroll = event.maxScroll;
      double currentScroll = event.currentScroll;
      double delta = event.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        _streamFeeds();
        emit(_uploadFeedFields());
      }
    } catch (error) {
      emit(error is FeedStateError
          ? FeedStateError(error.message)
          : FeedStateError('Algo fue mal al cambiar de pestaña!'));
    }
  }

  void _uploadFeedFieldsEvent(UploadFeedFieldsEvent event, Emitter emit) async {
    emit(_uploadFeedFields());
  }

  FeedState _uploadFeedFields() => UploadFeedFieldsState(feeds: _feeds);

  @override
  Future<void> close() {
    _feedSubscription?.cancel();
    return super.close();
  }
}
