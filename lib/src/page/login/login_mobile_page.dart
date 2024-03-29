import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/state/auth_state.dart';
import 'package:yodravet/src/shared/platform_discover.dart';
import 'package:yodravet/src/widget/custom_button.dart';
import 'package:yodravet/src/widget/custom_snackbar.dart';

import '../../route/app_router_delegate.dart';
import 'login_basic_page.dart';

class LoginMobilePage extends LoginBasicPage {
  const LoginMobilePage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    bool isLoading = false;
    bool isLoadingGoogle = false;
    bool isLoadingApple = false;
    TextEditingController emailTextController = TextEditingController();
    TextEditingController passTextController = TextEditingController();

    return BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, state) {
      if (state is LogInSuccessState) {
        isLoading = false;
        isLoadingGoogle = false;
        isLoadingApple = false;
        // SchedulerBinding.instance!.addPostFrameCallback((_) {
        //   routerDelegate.pushPageAndRemoveUntil(name: '/userPage');
        // });
      } else if (state is AuthLoadingState) {
        isLoading = state.isLoading;
        isLoadingGoogle = state.isLoadingGoogle;
        isLoadingApple = state.isLoadingApple;
      } else if (state is ChangePasswordSuccessState) {
        CustomSnackBar().show(
            context: context,
            message: 'Se ha enviado un correo electrónico a tu cuenta '
                'con instrucciones',
            iconData: FontAwesomeIcons.circleExclamation);
      } else if (state is Go2SignupState) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          // Navigator.pop(context);
          routerDelegate.pushPage(name: '/signupPage');
          BlocProvider.of<AuthBloc>(context).add(AuthEventEmpty());
        });
      } else if (state is InitTermsState) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          routerDelegate.pushPage(name: '/termsPage');
          BlocProvider.of<AuthBloc>(context).add(AuthEventEmpty());
        });
      } else if (state is InitCollaborateState) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          routerDelegate.pushPage(name: '/collaboratePage');
          BlocProvider.of<AuthBloc>(context).add(AuthEventEmpty());
        });
      } else if (state is AuthStateError) {
        isLoading = false;
        isLoadingGoogle = false;
        isLoadingApple = false;
        CustomSnackBar().show(
            context: context,
            message: state.message,
            iconData: FontAwesomeIcons.circleExclamation);
      }

      return Container(
        color: const Color.fromRGBO(153, 148, 86, 1),
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 16.0, bottom: 2.0),
              child: CustomButton(
                color: Colors.red,
                onPressed: () {
                  // routerDelegate.popRoute();
                  BlocProvider.of<AuthBloc>(context).add(GoogleLogInEvent());
                },
                child: isLoadingGoogle
                    // ? null
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.white)
                    : isLoading || isLoadingApple
                        ? null
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.google,
                                  color: Colors.white),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Iniciar sesión con Google',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
              ),
            ),
            Visibility(
              visible: _visibleIfPlatform(context),
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 2.0, bottom: 2.0),
                child: CustomButton(
                  color: Colors.black,
                  onPressed: () {
                    // routerDelegate.popRoute();
                    BlocProvider.of<AuthBloc>(context).add(AppleLogInEvent());
                  },
                  child: isLoadingApple
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white)
                      : isLoading || isLoadingGoogle
                          ? null
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.apple,
                                    color: Colors.white),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Iniciar sesión con Apple',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                ),
              ),
            ),
            Center(child: Text(AppLocalizations.of(context)!.logInO)),
            Container(
              margin: const EdgeInsets.only(
                  left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
              child: TextFormField(
                controller: emailTextController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Usuario', hintText: 'Correo electrónico'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
              child: TextFormField(
                controller: passTextController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
                obscureText: true,
                onFieldSubmitted: (_) {
                  BlocProvider.of<AuthBloc>(context).add(LogInEvent(
                      email: emailTextController.text,
                      pass: passTextController.text));
                },
              ),
            ),
            CustomButton(
              child: isLoading
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.white)
                  : isLoadingGoogle || isLoadingApple
                      ? null
                      : Text(AppLocalizations.of(context)!.logIn,
                          style: const TextStyle(color: Colors.white)),
              onPressed: () {
                // routerDelegate.popRoute();
                BlocProvider.of<AuthBloc>(context).add(LogInEvent(
                    email: emailTextController.text,
                    pass: passTextController.text));
              },
            ),
            Row(
              children: [
                TextButton(
                  child: const Text(
                    'No recuerdo mi contraseña',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(ChangePasswordEvent(emailTextController.text));
                  },
                ),
                const Spacer(),
                TextButton(
                  child: const Text(
                    'Registrarme',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(Go2SignupEvent());
                  },
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  bool _visibleIfPlatform(BuildContext context) {
    if (PlatformDiscover.isWeb()) {
      if (PlatformDiscover.isMacOs(context)) {
        return false;
      }
    } else if (Platform.isIOS || Platform.isMacOS) {
      return true;
    }

    return false;
  }
}
