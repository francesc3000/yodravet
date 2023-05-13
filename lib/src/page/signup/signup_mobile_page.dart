import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/signup_event.dart';
import 'package:yodravet/src/bloc/signup_bloc.dart';
import 'package:yodravet/src/bloc/state/signup_state.dart';
import 'package:yodravet/src/widget/custom_button.dart';
import 'package:yodravet/src/widget/custom_snackbar.dart';

import '../../route/app_router_delegate.dart';
import 'signup_basic_page.dart';

class SignupMobilePage extends SignupBasicPage {
  const SignupMobilePage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    bool isLoading = false;
    TextEditingController emailTextController = TextEditingController();
    TextEditingController passTextController = TextEditingController();
    TextEditingController passCopyTextController = TextEditingController();
    TextEditingController nameTextController = TextEditingController();
    TextEditingController lastnameTextController = TextEditingController();
    String? emailError = '';
    String? nameError = '';
    String? lastnameError = '';
    String? passwordError = '';
    String? passwordCopyError = '';

    return BlocBuilder<SignupBloc, SignupState>(
        builder: (BuildContext context, state) {
      if (state is UpdateSignupFieldsState) {
        emailTextController.text = state.signup.email!;
        nameTextController.text = state.signup.name!;
        lastnameTextController.text = state.signup.lastname!;
        passTextController.text = state.signup.password!;
        passCopyTextController.text = state.signup.passwordCopy!;
        emailError = state.signup.emailError;
        nameError = state.signup.nameError;
        lastnameError = state.signup.lastnameError;
        passwordError = state.signup.passwordError;
        passwordCopyError = state.signup.passwordCopyError;
        isLoading = state.isLoading;
      } else if (state is SignUpSuccessState) {
        isLoading = false;
        BlocProvider.of<SignupBloc>(context).add(SignupEventEmpty());
        SchedulerBinding.instance.addPostFrameCallback((_) {
          routerDelegate.pushPageAndRemoveUntil(name: '/');
        });
      } else if (state is SignupStateError) {
        isLoading = false;
        CustomSnackBar().show(
            context: context,
            message: state.message,
            iconData: FontAwesomeIcons.circleExclamation);
      }
      //TODO:Quitar WillPopScope
      return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Container(
          color: const Color.fromRGBO(153, 148, 86, 60),
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Correo electrónico', errorText: emailError),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: nameTextController,
                  decoration: InputDecoration(
                      labelText: 'Nombre', errorText: nameError),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: lastnameTextController,
                  decoration: InputDecoration(
                      labelText: 'Apellidos', errorText: lastnameError),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: passTextController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: 'Contraseña', errorText: passwordError),
                  obscureText: true,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: passCopyTextController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: 'Repetir contraseña',
                      errorText: passwordCopyError),
                  obscureText: true,
                ),
              ),
              CustomButton(
                child: isLoading
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.white)
                    : Text(
                        AppLocalizations.of(context)!.signIn,
                        style: const TextStyle(color: Colors.white),
                      ),
                onPressed: () {
                  BlocProvider.of<SignupBloc>(context).add(SignUpEvent(
                    emailTextController.text,
                    nameTextController.text,
                    lastnameTextController.text,
                    passTextController.text,
                    passCopyTextController.text,
                  ));
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    BlocProvider.of<AuthBloc>(context).add(AuthEventEmpty());
    return true;
  }
}
