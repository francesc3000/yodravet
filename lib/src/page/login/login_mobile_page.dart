import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/state/auth_state.dart';
import 'package:yodravet/src/locale/locales.dart';
import 'package:yodravet/src/routes/route_name.dart';
import 'package:yodravet/src/widget/custom_button.dart';
import 'package:yodravet/src/widget/custom_snackbar.dart';

import 'login_basic_page.dart';

class LoginMobilePage extends LoginBasicPage {
  LoginMobilePage(String title) : super(title);

  Widget body(BuildContext context) {
    bool _isLoading = false;
    bool _isLoadingGoogle = false;
    bool _isLoadingApple = false;
    TextEditingController emailTextController = TextEditingController();
    TextEditingController passTextController = TextEditingController();

    // emailTextController.text = 'bigroiclub@gmail.com';
    // passTextController.text = r'5%Fks13v';

    return BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, state) {
      if (state is LogInSuccessState) {
        _isLoading = false;
        _isLoadingGoogle = false;
        _isLoadingApple = false;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
          Navigator.pushNamed(
              context, '/' + RouteName.userPage);
        });
      } else if (state is AuthLoadingState) {
        _isLoading = state.isLoading;
        _isLoadingGoogle = state.isLoadingGoogle;
        _isLoadingApple = state.isLoadingApple;
      } else if (state is ChangePasswordSuccessState) {
        CustomSnackBar().show(
            context: context,
            message: 'Se ha enviado un correo electrónico a tu cuenta con instrucciones',
            iconData: FontAwesomeIcons.exclamationCircle);
      } else if (state is AuthStateError) {
        _isLoading = false;
        _isLoadingGoogle = false;
        _isLoadingApple = false;
        CustomSnackBar().show(
            context: context,
            message: state.message,
            iconData: FontAwesomeIcons.exclamationCircle);
      }

      return ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 16.0, bottom: 2.0),
            child: CustomButton(
              child: _isLoadingGoogle
                ? CircularProgressIndicator(backgroundColor: Colors.white)
                : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.google, color: Colors.white),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Google',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<AuthBloc>(context).add(GoogleLogInEvent());
              },
            ),
          ),
          Visibility(
            visible: Platform.isIOS || Platform.isMacOS ? true : false,
            child: Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 2.0, bottom: 2.0),
              child: CustomButton(
                child: _isLoadingApple
                ? CircularProgressIndicator(backgroundColor: Colors.white)
                : 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.apple, color: Colors.white),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Apple',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<AuthBloc>(context).add(AppleLogInEvent());
                },
              ),
            ),
          ),
          Center(child: Text(AppLocalizations.of(context).logInO)),
          Container(
            margin:
                EdgeInsets.only(left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
            child: TextFormField(
              controller: emailTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'Usuario', hintText: 'Correo electrónico'),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
            child: TextFormField(
              controller: passTextController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
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
            child: _isLoading
                ? CircularProgressIndicator(backgroundColor: Colors.white)
                : Text(AppLocalizations.of(context).logIn, style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<AuthBloc>(context).add(LogInEvent(
                  email: emailTextController.text,
                  pass: passTextController.text));
            },
          ),
          Row(
            children: [
              TextButton(
                child: Text(
                  'No recuerdo mi contraseña',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(ChangePasswordEvent(emailTextController.text));
                },
              ),
              Spacer(),
              TextButton(
                child: Text(
                  'Registrarme',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/' + RouteName.signupPage);
                },
              )
            ],
          ),
        ],
      );
    });
  }
}
