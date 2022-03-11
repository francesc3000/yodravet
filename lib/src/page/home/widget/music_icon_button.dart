import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';

class MusicIconButton extends StatelessWidget {
  final bool isMusicOn;
  const MusicIconButton({Key? key, required this.isMusicOn}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: () {
        BlocProvider.of<HomeBloc>(context).add(ChangeMuteOptionEvent());
      },
      icon: isMusicOn
          ? const Icon(FontAwesomeIcons.music)
          : const Icon(FontAwesomeIcons.pause),
    );
}
