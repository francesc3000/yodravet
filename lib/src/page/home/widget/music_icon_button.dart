import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

class MusicIconButton {
  BuildContext context;

  MusicIconButton(this.context);

  Widget getMusicIcon(bool isMusicOn) => PopupMenuButton(
      color: const Color.fromARGB(255, 140, 71, 153),
      icon: isMusicOn
          ? const Icon(
              FontAwesomeIcons.music,
              color: Colors.white,
            )
          : const Icon(FontAwesomeIcons.pause, color: Colors.white),
      itemBuilder: (context) => _getPopupMenuItem(context, isMusicOn));

  Widget getPurchaseMusicIcon() => IconButton(
        icon: const Icon(FontAwesomeIcons.cartShopping),
        onPressed: () =>
            BlocProvider.of<RaceBloc>(context).add(PurchaseSongEvent()),
        // label: Text(
        //   AppLocalizations.of(context)!.buySong,
        //   style: const TextStyle(color: Colors.white),
        // ),
      );

  List<PopupMenuEntry<int>> _getPopupMenuItem(
      BuildContext context, bool isMusicOn) {
    if (PlatformDiscover.isIOs(context)) {
      return [
        PopupMenuItem(
          value: 1,
          onTap: () => BlocProvider.of<HomeBloc>(context).add(
            ChangeMuteOptionEvent(),
          ),
          child: isMusicOn
              ? Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pause,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    const Icon(FontAwesomeIcons.pause),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.play,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    const Icon(FontAwesomeIcons.music),
                  ],
                ),
        ),
      ];
    } else {
      return [
        PopupMenuItem(
          value: 1,
          onTap: () => BlocProvider.of<HomeBloc>(context).add(
            ChangeMuteOptionEvent(),
          ),
          child: isMusicOn
              ? Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pause,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    const Icon(FontAwesomeIcons.pause),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.play,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    const Icon(FontAwesomeIcons.music),
                  ],
                ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () =>
              BlocProvider.of<RaceBloc>(context).add(PurchaseSongEvent()),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.buySong,
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              const Icon(FontAwesomeIcons.cartShopping),
            ],
          ),
        ),
      ];
    }
  }
}
