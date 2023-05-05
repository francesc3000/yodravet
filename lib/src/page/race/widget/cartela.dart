import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/race_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';

class Cartela extends StatelessWidget {
  const Cartela({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(vertical: 132.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: GestureDetector(
              onTap: () => BlocProvider.of<RaceBloc>(context)
                  .add(PurchaseButterfliesEvent()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset("assets/images/logo.webp"),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(3.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text:
                            "Abierto a todos. Cualquier actividad física.\n",
                            style: DefaultTextStyle.of(context).style,
                            children: const [
                              TextSpan(text: "Registro gratuito.\n"),
                              TextSpan(
                                text: "#YoParticipo  #YoDono",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 20),
                              )
                            ]),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child:
                    Image.asset("assets/images/race/logoYoCorro.webp"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.shareNodes,
                color: Color.fromARGB(255, 140, 71, 153),
              ),
              onPressed: () => BlocProvider.of<RaceBloc>(context)
                  .add(ShareCartelaEvent()),
            ),
          ),
        ],
      ),
    );
}
