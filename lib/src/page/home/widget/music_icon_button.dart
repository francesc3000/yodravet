import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';

class MusicIconButton extends StatelessWidget {
  final bool isMusicOn;
  const MusicIconButton({Key? key, required this.isMusicOn}) : super(key: key);

  @override
  Widget build(BuildContext context) => PopupMenuButton(
      icon: isMusicOn
          ? const Icon(FontAwesomeIcons.music)
          : const Icon(FontAwesomeIcons.pause),
      itemBuilder: (context) => [
            PopupMenuItem(
              child:
                  isMusicOn ? Row(
                    children: const [
                      Text("Pausar"),
                      Icon(FontAwesomeIcons.pause),
                    ],
                  ) : Row(
                    children: const [
                      Text("Reproducir"),
                      Icon(FontAwesomeIcons.music),
                    ],
                  ),
              value: 1,
              onTap: () => BlocProvider.of<HomeBloc>(context)
                  .add(ChangeMuteOptionEvent()),
            ),
            PopupMenuItem(
              child: const Text.rich(
                TextSpan(
                    text:
                    "Comp",
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.add_shopping_cart,
                        ),
                      ),
                    ]),
              ),
              // child: Row(
              //   children: const [
              //     Text("Comprar"),
              //     Icon(FontAwesomeIcons.shoppingCart),
              //   ],
              // ),
              value: 2,
              onTap: () =>
                  BlocProvider.of<HomeBloc>(context).add(PurchaseSongEvent()),
            ),
          ]);
}
