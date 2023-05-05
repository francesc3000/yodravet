import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/collaborate_bloc.dart';
import 'package:yodravet/src/bloc/event/collaborate_event.dart';
import 'package:yodravet/src/bloc/state/collaborate_state.dart';

import '../../route/app_router_delegate.dart';
import 'collaborate_basic_page.dart';

class CollaborateMobilePage extends CollaborateBasicPage {
  const CollaborateMobilePage(AppRouterDelegate routerDelegate, {Key? key})
      : super(routerDelegate, key: key);

  @override
  Widget body(BuildContext context) =>
      BlocBuilder<CollaborateBloc, CollaborateState>(
        builder: (context, state) {
          bool _loading = false;

          if (state is CollaborateInitState) {
            // _loading = true;
          } else if (state is UploadCollaborateFields) {
            _loading = false;
          }

          if (_loading) {
            return Container(
              alignment: Alignment.center,
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: const CircularProgressIndicator(),
            );
          }

          return Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 60.0),
            color: const Color.fromRGBO(153, 148, 86, 1),
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: RichText(
                    text: TextSpan(
                      text:
                          'Ahora puedes contribuir a la investigación contra el Dravet.\n',
                      style: DefaultTextStyle.of(context).style,
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Realiza tu donación voluntaria\n\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '¡Ahora es el momento!\n\n'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                    child: Image.asset("assets/images/race/logoYoCorro.webp"),
                ),
                Expanded(
                  flex: 1,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          onPressed: () {
                            BlocProvider.of<CollaborateBloc>(context)
                                .add(MaybeLaterEvent());
                            routerDelegate.popRoute();
                          },
                          child: const Text(
                            "Quizás después",
                            style: TextStyle(
                                color: Color.fromARGB(255, 140, 71, 153)),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CollaborateBloc>(context)
                                .add(ICollaborateEvent());
                            routerDelegate.popRoute();
                          },
                          child: const Text("Vamos")),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
}
