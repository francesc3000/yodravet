import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/signup_event.dart';
import 'package:yodravet/src/bloc/signup_bloc.dart';
import 'package:yodravet/src/bloc/state/signup_state.dart';
import 'package:yodravet/src/locale/locales.dart';
import 'package:yodravet/src/widget/custom_button.dart';
import 'package:yodravet/src/widget/custom_snackbar.dart';

import 'signup_basic_page.dart';

class SignupDesktopPage extends SignupBasicPage {
  SignupDesktopPage(String title) : super(title);

  @override
  PreferredSizeWidget appBar(BuildContext context, {String title}) {
    return null;
  }

  Widget body(BuildContext context) {
    bool _isLoading = false;
    TextEditingController _emailTextController = TextEditingController();
    TextEditingController _passTextController = TextEditingController();
    TextEditingController _passCopyTextController = TextEditingController();
    TextEditingController _nameTextController = TextEditingController();
    TextEditingController _lastnameTextController = TextEditingController();
    String _emailError = '';
    String _nameError = '';
    String _lastnameError = '';
    String _passwordError = '';
    String _passwordCopyError = '';

    return BlocBuilder<SignupBloc, SignupState>(
        builder: (BuildContext context, state) {
      if (state is UpdateSignupFieldsState) {
        _emailTextController.text = state.signup.email;
        _nameTextController.text = state.signup.name;
        _lastnameTextController.text = state.signup.lastname;
        _passTextController.text = state.signup.password;
        _passCopyTextController.text = state.signup.passwordCopy;
        _emailError = state.signup.emailError;
        _nameError = state.signup.nameError;
        _lastnameError = state.signup.lastnameError;
        _passwordError = state.signup.passwordError;
        _passwordCopyError = state.signup.passwordCopyError;
        _isLoading = state.isLoading;
      } else if (state is SignUpSuccessState) {
        _isLoading = false;
        BlocProvider.of<SignupBloc>(context).add(SignupEventEmpty());
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        });
      } else if (state is SignupStateError) {
        _isLoading = false;
        CustomSnackBar().show(
            context: context,
            message: state.message,
            iconData: FontAwesomeIcons.exclamationCircle);
      }
      return WillPopScope(
        onWillPop: () {
          return _onWillPop(context);
        },
        child: Container(
          color: Color.fromRGBO(153, 148, 86, 60),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Correo electr??nico', errorText: _emailError),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: _nameTextController,
                  decoration: InputDecoration(
                      labelText: 'Nombre', errorText: _nameError),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: _lastnameTextController,
                  decoration: InputDecoration(
                      labelText: 'Apellidos', errorText: _lastnameError),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: _passTextController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: 'Contrase??a', errorText: _passwordError),
                  obscureText: true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 28.0, right: 28.0, top: 2.0, bottom: 8.0),
                child: TextFormField(
                  controller: _passCopyTextController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: 'Repetir contrase??a',
                      errorText: _passwordCopyError),
                  obscureText: true,
                ),
              ),
              CustomButton(
                child: _isLoading
                    ? CircularProgressIndicator(backgroundColor: Colors.white)
                    : Text(
                        AppLocalizations.of(context).signIn,
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: () {
                  BlocProvider.of<SignupBloc>(context).add(SignUpEvent(
                    _emailTextController.text,
                    _nameTextController.text,
                    _lastnameTextController.text,
                    _passTextController.text,
                    _passCopyTextController.text,
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
