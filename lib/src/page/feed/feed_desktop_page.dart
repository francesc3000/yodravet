import 'package:any_link_preview/any_link_preview.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/feed_event.dart';
import 'package:yodravet/src/bloc/feed_bloc.dart';
import 'package:yodravet/src/bloc/state/feed_state.dart';
import 'package:yodravet/src/model/feed.dart';
import 'package:yodravet/src/widget/sliver_appbar_delegate.dart';

import '../../route/app_router_delegate.dart';
import 'feed_basic_page.dart';

class FeedDesktopPage extends FeedBasicPage {
  const FeedDesktopPage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    List<Widget> slivers = [];
    bool _loading = false;
    List<Feed> _feeds = [];
    // ScrollController _scrollController = ScrollController();

    // _scrollController.addListener(() {
    //   double maxScroll = _scrollController.position.maxScrollExtent;
    //   double currentScroll = _scrollController.position.pixels;
    //   double height = MediaQuery.of(context).size.height;
    //   BlocProvider.of<FeedBloc>(context)
    //       .add(FetchNextPageEvent(maxScroll, currentScroll, height));
    // });

    return BlocBuilder<FeedBloc, FeedState>(
      builder: (BuildContext context, state) {
        if (state is FeedInitState) {
          BlocProvider.of<FeedBloc>(context).add(LoadInitialDataEvent());
          _loading = true;
        } else if (state is UploadFeedFieldsState) {
          _loading = false;
          _feeds = state.feeds;
        } else if (state is FeedStateError) {
          //TODO: Mostrar errores en Pages
          // CustomSnackBar
        }

        if (_loading) {
          return Container(
              alignment: Alignment.center,
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: const Center(child: CircularProgressIndicator()));
        }

        return Container(
          color: const Color.fromRGBO(153, 148, 86, 1),
        );

        slivers.clear();
        slivers.add(_buildFeed(_feeds));
        slivers.add(_buildHeaderFeed());

        return Container(
          padding: const EdgeInsets.only(
              left: 8.0, top: 8.0, right: 8.0, bottom: 35.0),
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: CustomScrollView(
            // controller: _scrollController,
            slivers: slivers,
            reverse: true,
          ),
        );
      },
    );
  }

  Widget _buildHeaderFeed() => SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: const Text("No te pierdas nada con nuestro panel de noticias"),
        ),
      ));

  Widget _buildFeed(List<Feed> feeds) {
    List<Widget> messages = [];
    for (var feed in feeds) {
      if (feed.hasLink) {
        messages.add(
          AnyLinkPreview(
            link: feed.link!,
            displayDirection: UIDirection.uiDirectionHorizontal,
            // showMultimedia: false,
            bodyMaxLines: 10,
            bodyTextOverflow: TextOverflow.ellipsis,
            titleStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            bodyStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            errorBody: "No se ha podido cargar el enlace",
            errorTitle: "Enlace roto",
            errorWidget: Container(
              color: Colors.grey[300],
              child: const Text('Ups!'),
            ),
            errorImage: "https://firebasestorage.googleapis.com/v0/b/yo-corro-por-el-dravet.appspot.com/o/app%2FlogoYoCorroSinFondo.png?alt=media&token=c814d3a8-d6de-40ca-b936-0bd2740ff75e",
            cache: const Duration(days: 25),
            backgroundColor: Colors.grey[300],
            borderRadius: 12,
            removeElevation: false,
            boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
            // onTap: (){}, // This disables tap event
          ),
        );
      }

      if(feed.message.isNotEmpty) {
        messages.add(
          Bubble(
            margin: const BubbleEdges.only(top: 10),
            color: const Color.fromARGB(255, 140, 71, 153),
            child: Text(
              feed.message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
    return SliverList(
      delegate: SliverChildListDelegate(messages),
    );
  }
}
