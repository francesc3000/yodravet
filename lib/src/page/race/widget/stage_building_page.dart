import 'package:flutter/material.dart';
import 'package:yodravet/src/model/stage_building.dart';

class StageBuildingPage extends StatelessWidget {
  final StageBuilding stageBuilding;
  final double expandedHeight;
  final double leadingWidth;

  const StageBuildingPage(
      {Key key, this.stageBuilding, this.expandedHeight=300, this.leadingWidth=300})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [];

    slivers.clear();
    slivers.add(_buildHeader(context, stageBuilding.name, stageBuilding.photo, expandedHeight, leadingWidth));
    slivers.add(_buildBody(context, stageBuilding.description));

    return CustomScrollView(
      slivers: slivers,
    );
  }

  Widget _buildHeader(BuildContext context, String name, String image, double expandedHeight, double leadingWidth) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      leadingWidth: leadingWidth,
      backgroundColor: Colors.white,
      floating: false,
      pinned: true,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      // ),
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: EdgeInsets.symmetric(vertical: 16.0),
        // centerTitle: true,
        title: Text(name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            )),
        background: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
    // return SliverPersistentHeader(
    //   // floating: true,
    //   // pinned: true,
    //   delegate: SliverAppBarDelegate(
    //     minHeight: MediaQuery.of(context).size.height / 5,
    //     maxHeight: MediaQuery.of(context).size.height /2,
    //     child: Container(
    //       color: Colors.white,
    //       child: Image.asset(image),
    //     ),
    //   ),
    // );
  }

  Widget _buildBody(BuildContext context, String description) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Card(
          child: Text(stageBuilding.description),
        ),
      ]),
    );
  }
}
