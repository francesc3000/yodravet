import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/event/terms_event.dart';
import 'package:yodravet/src/bloc/state/terms_state.dart';
import 'package:yodravet/src/bloc/terms_bloc.dart';
import 'package:yodravet/src/page/terms/terms_basic_page.dart';
import 'package:yodravet/src/page/terms/widget/terms_and_conditions.dart';
import 'package:yodravet/src/route/app_router_delegate.dart';

class TermsDesktopPage extends TermsBasicPage {
  const TermsDesktopPage(AppRouterDelegate routerDelegate, {Key? key})
      : super(routerDelegate, key: key);

  @override
  Widget body(BuildContext context) => BlocBuilder<TermsBloc, TermsState>(
    builder: (context, state) {
      bool loading = false;

      if (state is TermsInitState) {
        // _loading = true;
      } else if (state is UploadTermsFields) {
        loading = false;
      }

      if (loading) {
        return Container(
          alignment: Alignment.center,
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: const CircularProgressIndicator(),
        );
      }

      return Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 60.0),
        // height: double.infinity,
        // width: double.infinity,
        color: const Color.fromRGBO(153, 148, 86, 1),
        // alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text:
                  'Para nosotros es importante que comprendas como manejamos ',
                  style: DefaultTextStyle.of(context).style,
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'tus datos personales. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                        'A continuación te damos una pequeña explicación. Con todo lujo de detalles\n'),
                    TextSpan(
                        text:
                        'Puedes aceptar los terminos y condiciones para continuar.'),
                  ],
                ),
              ),
            ),
            const Expanded(flex: 6, child: TermsAndConditions()),
            Expanded(
              flex: 1,
              child: ButtonBar(
                children: [
                  MaterialButton(
                      onPressed: () {
                        BlocProvider.of<TermsBloc>(context)
                            .add(RejectTermsEvent());
                        routerDelegate.popRoute();
                      },
                      child: const Text(
                        "Rechazar",
                        style: TextStyle(
                            color: Color.fromARGB(255, 140, 71, 153)),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<TermsBloc>(context)
                            .add(AcceptTermsEvent());
                        routerDelegate.popRoute();
                      },
                      child: const Text("Aceptar")),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
