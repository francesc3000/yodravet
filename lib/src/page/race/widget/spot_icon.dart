import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';
import 'package:yodravet/src/bloc/state/race_state.dart';

class SpotIcon extends StatelessWidget {
  final String id;
  final String name;
  final String photo;
  final int vote;
  final double height;
  final double width;

  const SpotIcon(this.id,
      {Key? key,
      this.name = '',
      this.photo = '',
      this.vote = 0,
      this.height = 60,
      this.width = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _currentId = '';
    String _currentMouseId = '';

    return BlocBuilder<RaceBloc, RaceState>(
        builder: (BuildContext context, state) {
      if (state is UpdateRaceFieldsState) {
        _currentId = state.currentSpot?.id ?? '';
        _currentMouseId = state.currentMouseSpot?.id ?? '';
      }

      return MouseRegion(
        onEnter: (_) =>
            BlocProvider.of<RaceBloc>(context).add(MouseOnEnterEvent(id)),
        onExit: (_) =>
            BlocProvider.of<RaceBloc>(context).add(MouseOnExitEvent()),
        child: RawMaterialButton(
          onPressed: () {
            BlocProvider.of<RaceBloc>(context).add(ClickOnMapEvent(id));
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Transform.scale(
                scale: _currentId.compareTo(id) == 0 ||
                        _currentMouseId.compareTo(id) == 0
                    ? 1
                    : 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(photo),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    height: height,
                    width: width,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: -15,
                child: Transform.translate(
                  offset: _currentId.compareTo(id) == 0 ||
                          _currentMouseId.compareTo(id) == 0
                      ? const Offset(0.0, 20.0)
                      : const Offset(0.0, 5.0),
                  child: SizedBox(
                    width: 85,
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Positioned(
                // top: 10,
                left: 40,
                child: badges.Badge(
                  badgeContent: Text(vote.toString()),
                  // child: Icon(Icons.settings),
                ),
              ),
            ],
          ),
          shape: const CircleBorder(),
        ),
      );
    });
  }
}
