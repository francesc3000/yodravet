import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/user_event.dart';
import 'package:yodravet/src/bloc/state/user_state.dart';
import 'package:yodravet/src/bloc/user_bloc.dart';

class StravaSwitch extends StatelessWidget {
  final bool calcVisibility;
  const StravaSwitch({super.key, this.calcVisibility = false});

  @override
  Widget build(BuildContext context) {
    bool isStravaLogin = false;
    bool lockStravaLogin = false;
    bool visible = false;

    return BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, state) {
      if (state is UserInitState) {
        BlocProvider.of<UserBloc>(context).add(LoadInitialDataEvent());
      } else if (state is UploadUserFieldsState) {
        isStravaLogin = state.isStravaLogin ?? false;
        lockStravaLogin = state.lockStravaLogin;
      } else if (state is UserStateError) {
        //TODO: Mostrar errores en Pages
        // CustomSnackBar
      }

      if (calcVisibility) {
        if (isStravaLogin) {
          visible = false;
        }
      } else {
        visible = true;
      }

      return Visibility(
        visible: visible,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: Row(
            children: [
              Text(AppLocalizations.of(context)!.stravaConnect),
              const Icon(FontAwesomeIcons.strava, color: Colors.orange),
              const Spacer(),
              Switch(
                  activeColor: Colors.green,
                  inactiveThumbColor:
                      lockStravaLogin ? Colors.grey : Colors.red,
                  value: isStravaLogin,
                  onChanged: lockStravaLogin
                      ? null
                      : (_) {
                          BlocProvider.of<UserBloc>(context)
                              .add(ConnectWithStravaEvent());
                        }),
            ],
          ),
        ),
      );
    });
  }
}
