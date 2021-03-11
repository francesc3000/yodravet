import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';

class StageBuildingIcon extends StatelessWidget {
  final String id;
  final String name;
  final String photo;
  final double height;
  final double width;

  const StageBuildingIcon(this.id,
      {Key key,
      this.name = '',
      this.photo = '',
      this.height = 60,
      this.width = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        BlocProvider.of<RaceBloc>(context).add(ClickOnMapEvent(id));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(photo),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: height,
              width: width,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              name,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      shape: CircleBorder(),
    );
  }
}
