import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';
import 'package:yodravet/src/model/race_spot.dart';
import 'package:yodravet/src/model/researcher.dart';
import 'package:yodravet/src/model/spot.dart';

class SpotPage extends StatefulWidget {
  final Spot? spot;
  final bool isVoted;
  final bool canVote;
  final bool hasVote;
  final RaceSpot? raceSpot;
  final double expandedHeight;
  final double leadingWidth;
  final BoxFit imageFit;

  const SpotPage(
      {Key? key,
      required this.spot,
      required this.isVoted,
      required this.canVote,
      required this.hasVote,
      this.raceSpot,
      this.expandedHeight = 300,
      this.leadingWidth = 300,
      this.imageFit = BoxFit.fitHeight})
      : super(key: key);

  @override
  State<SpotPage> createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage> {
  bool? isVoted;

  _SpotPageState();

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [];

    isVoted ??= widget.isVoted;

    slivers.clear();
    slivers.add(_buildHeader(
        context,
        widget.spot!.name,
        widget.spot!.photo,
        widget.expandedHeight,
        widget.leadingWidth,
        widget.imageFit,
        widget.spot!.id,
        widget.canVote,
        widget.hasVote));
    slivers.add(_buildBody(context, widget.spot!.researchers));

    return CustomScrollView(
      slivers: slivers,
    );
  }

  Widget _buildHeader(
          BuildContext context,
          String name,
          String image,
          double expandedHeight,
          double leadingWidth,
          BoxFit imageFit,
          String spotId,
          bool canVote,
          bool hasVote) =>
      SliverAppBar(
        automaticallyImplyLeading: false, //Quita backbutton
        expandedHeight: expandedHeight,
        leadingWidth: leadingWidth,
        backgroundColor: const Color.fromRGBO(153, 148, 86, 1),
        floating: false,
        pinned: true,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        // ),
        flexibleSpace: FlexibleSpaceBar(
          // titlePadding: EdgeInsets.symmetric(vertical: 16.0),
          centerTitle: true,
          title: Text(
            name,
            style: const TextStyle(
              // color: Color.fromRGBO(140, 71, 153, 1),
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          background: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  image,
                  fit: imageFit,
                ),
              )
            ],
          ),
        ),
        actions: [_thumbUp(context, spotId, canVote, hasVote)],
      );

  Widget _buildBody(BuildContext context, List<Researcher> researchers) =>
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              MediaQuery.of(context).size.width >= 720
                  ? _buildResearcherRow(context, researchers[index])
                  : _buildResearcherColumn(context, researchers[index]),
          childCount: researchers.length,
        ),
      );

  Widget _buildResearcherRow(BuildContext context, Researcher researcher) =>
      Container(
        color: const Color.fromRGBO(153, 148, 86, 60),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        researcher.name,
                        style: const TextStyle(
                            fontSize: 30.0,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  Text(
                    researcher.description,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Visibility(
                    visible: researcher.link.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                          child: const Text(
                            'Más información',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          onTap: () => launchUrl(Uri.parse(researcher.link))),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Visibility(
                  visible: researcher.photo.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(researcher.photo),
                  )),
            ),
          ],
        ),
      );

  Widget _buildResearcherColumn(BuildContext context, Researcher researcher) =>
      Container(
        color: const Color.fromRGBO(153, 148, 86, 60),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              researcher.name,
              style: const TextStyle(
                  fontSize: 30.0, decoration: TextDecoration.underline),
            ),
            Text(
              researcher.description,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            Visibility(
              visible: researcher.link.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                    child: const Text(
                      'Más información',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onTap: () => launchUrl(Uri.parse(researcher.link))),
              ),
            ),
            Visibility(
                visible: researcher.photo.isNotEmpty,
                child: Image.asset(researcher.photo)),
          ],
        ),
      );

  Widget _thumbUp(
          BuildContext context, String spotId, bool canVote, bool hasVote) =>
      Visibility(
        visible: canVote,
        child: Container(
          alignment: Alignment.topRight,
          child: isVoted!
              ? IconButton(
                  icon: const Icon(FontAwesomeIcons.solidThumbsUp),
                  onPressed: () async {
                    setState(() {
                      isVoted = !isVoted!;
                      BlocProvider.of<RaceBloc>(context)
                          .add(SpotVoteThumbDownEvent(spotId));
                    });
                  })
              : Visibility(
                  visible: hasVote,
                  child: IconButton(
                      icon: const Icon(FontAwesomeIcons.thumbsUp),
                      onPressed: () async {
                        setState(() {
                          isVoted = !isVoted!;
                          BlocProvider.of<RaceBloc>(context)
                              .add(SpotVoteThumbUpEvent(spotId));
                        });
                      }),
                ),
        ),
      );
}
