import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/model/researcher.dart';
import 'package:yodravet/src/model/stage_building.dart';

class StageBuildingPage extends StatelessWidget {
  final StageBuilding? stageBuilding;
  final double expandedHeight;
  final double leadingWidth;
  final BoxFit imageFit;

  const StageBuildingPage(
      {Key? key,
      this.stageBuilding,
      this.expandedHeight = 300,
      this.leadingWidth = 300,
      this.imageFit = BoxFit.fitHeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [];

    slivers.clear();
    slivers.add(_buildHeader(context, stageBuilding!.name, stageBuilding!.photo,
        expandedHeight, leadingWidth, imageFit));
    slivers.add(_buildBody(context, stageBuilding!.researchers));

    return CustomScrollView(
      slivers: slivers,
    );
  }

  Widget _buildHeader(BuildContext context, String name, String image,
          double expandedHeight, double leadingWidth, BoxFit imageFit) =>
      SliverAppBar(
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
      );

  Widget _buildBody(BuildContext context, List<Researcher> researchers) =>
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              MediaQuery.of(context).size.width >= 720
                  ? _buildResearcherRow(researchers[index])
                  : _buildResearcherColumn(researchers[index]),
          childCount: researchers.length,
        ),
      );

  Widget _buildResearcherRow(Researcher researcher) => Container(
        color: const Color.fromRGBO(153, 148, 86, 60),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
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
                          onTap: () => launch(researcher.link)),
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

  Widget _buildResearcherColumn(Researcher researcher) => Container(
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
                    onTap: () => launch(researcher.link)),
              ),
            ),
            Visibility(
                visible: researcher.photo.isNotEmpty,
                child: Image.asset(researcher.photo)),
          ],
        ),
      );
}
