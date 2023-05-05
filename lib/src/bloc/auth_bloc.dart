import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/repository/interface/preferences.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

import 'event/auth_event.dart';
import 'event/session_event.dart' as session_event;
import 'event/session_event.dart';
import 'interface/session_interface.dart';
import 'state/auth_state.dart';
import 'state/session_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  User? _user;
  Preferences preferences;
  Session session;
  StreamSubscription? _sessionSubscription;

  AuthBloc(this.preferences, this.session) : super(AuthInitState()) {
    _sessionSubscription = session.stream.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          _user = session.user;
          add(InitPostLoginEvent());
        } else {
          add(LogOutSuccessEvent());
        }
      } else if (state is LogOutState) {
        add(LogOutSuccessEvent());
      } else if (state is UserChangeState) {
        _user = state.user;
      }
    });

    on<AuthEventEmpty>((event, emit) => emit(AuthInitState()));
    on<AutoLogInEvent>(_autoLoginEvent);
    on<LogInEvent>(_loginEvent);
    on<GoogleLogInEvent>(_googleLogInEvent);
    on<AppleLogInEvent>(_appleLogInEvent);
    on<StravaLogInEvent>(_stravaLogInEvent);
    on<LogOutEvent>(_logOutEvent);
    on<LogOutSuccessEvent>(_logOutSuccessEvent);
    on<SignedInEvent>(_signedInEvent);
    on<ChangePasswordEvent>(_changePasswordEvent);
    on<Go2SignupEvent>(_go2SignupEvent);
    on<InitPostLoginEvent>(_initPostLoginEvent);
    on<TermsRejectedEvent>(_termsRejectedEvent);
    on<TermsAcceptedEvent>(_termsAcceptedEvent);
    on<CollaborateMaybeLaterEvent>(_collaborateMaybeLaterEvent);
    on<CollaborateFinishEvent>(_collaborateFinishEvent);
  }

  void _autoLoginEvent(AutoLogInEvent event, Emitter emit) async {
    String? userEmail = '';
    String? password = '';

    if (kDebugMode) {
      print('Estoy en autologin en auth_bloc');
    }
    userEmail = preferences.getString('userEmail');
    password = preferences.getString('password');
    try {
      await session.autoLogIn(userEmail, password);
    } catch (error) {
      emit(error is AuthStateError
          ? AuthStateError(error.message)
          : AuthStateError('Algo fue mal en el AutoLogIn!'));
    }
  }

  void _loginEvent(LogInEvent event, Emitter emit) async {
    try {
      emit(AuthLoadingState(isLoading: true));
      try {
        _user = await session.logIn(event.email, event.pass);
      } on String catch (error) {
        throw AuthStateError(error);
      }
    } catch (error) {
      emit(error is AuthStateError
          ? AuthStateError(error.message)
          : AuthStateError('Algo fue mal en el LogIn!'));
    }
  }

  void _googleLogInEvent(GoogleLogInEvent event, Emitter emit) async {
    try {
      emit(AuthLoadingState(isLoadingGoogle: true));
      try {
        _user = await session.googleLogIn();
      } on auth.FirebaseAuthException catch (error) {
        throw AuthStateError(error.message);
      } on String catch (error) {
        throw AuthStateError(error);
      }
    } catch (error) {
      emit(error is AuthStateError
          ? AuthStateError(error.message)
          : AuthStateError('Algo fue mal en el LogIn de Google!'));
    }
  }

  void _appleLogInEvent(AppleLogInEvent event, Emitter emit) async {
    try {
      emit(AuthLoadingState(isLoadingApple: true));
      try {
        _user = await session.appleLogIn();
      } on auth.FirebaseAuthException catch (error) {
        throw AuthStateError(error.message);
      } on String catch (error) {
        throw AuthStateError(error);
      }
    } catch (error) {
      emit(error is AuthStateError
          ? AuthStateError(error.message)
          : AuthStateError('Algo fue mal en el LogIn de Apple!'));
    }
  }

  void _stravaLogInEvent(StravaLogInEvent event, Emitter emit) async {
    try {
      try {
        if (!PlatformDiscover.isWeb()) {
          _user!.isStravaLogin = await session.stravaLogIn();
        }
        session.add(UserChangeEvent(_user!));
      } on String catch (error) {
        throw AuthStateError(error);
      }
    } catch (error) {
      emit(error is AuthStateError
          ? AuthStateError(error.message)
          : AuthStateError('Algo fue mal en el LogIn de Strava!'));
    }
  }

  void _logOutEvent(LogOutEvent event, Emitter emit) async {
    try {
      if (_user!.isLogin) {
        preferences.logout();
        session.add(session_event.LogoutEvent());
      }
    } catch (error) {
      emit(error is AuthStateError
          ? AuthStateError(error.message)
          : AuthStateError('Algo fue mal en al cerrar la sessión!'));
    }
  }

  void _logOutSuccessEvent(LogOutSuccessEvent event, Emitter emit) async {
    emit(LogOutSuccessState());
  }

  void _signedInEvent(SignedInEvent event, Emitter emit) async {
    try {
      _keepUser(preferences, _user!, session.password);
      emit(LogInSuccessState(_user!));
    } catch (error) {
      emit(error is AuthStateError
          ? AuthStateError(error.message)
          : AuthStateError('Algo fue mal en al cerrar la sessión!'));
    }
  }

  void _changePasswordEvent(ChangePasswordEvent event, Emitter emit) async {
    try {
      if (event.email.isEmpty) {
        throw AuthStateError(
            'Por favor rellenar campo usuario con su correo electrónico');
      }
      if (await session.changePassword(event.email)) {
        add(LogOutEvent());
        emit(ChangePasswordSuccessState(_user!));
      }
    } catch (error) {
      emit(error is AuthStateError
          ? AuthStateError(error.message)
          : AuthStateError('Algo fue mal en el cambio de contraseña!'));
    }
  }

  void _go2SignupEvent(Go2SignupEvent event, Emitter emit) async {
    emit(Go2SignupState());
  }

  Future<bool> _keepUser(
      Preferences preferences, User user, String password) async {
    if (user.isLogin) {
      preferences.keepUser(
          'auth', user.id, user.email, password, user.fullName);
      return true;
    }

    return false;
  }

  void _initPostLoginEvent( InitPostLoginEvent event, Emitter emit) async {
    if(!_user!.hasTerms()){
      emit(InitTermsState());
    } else {
      if(preferences.isFirstLogin()) {
        emit(InitCollaborateState());
      } else {
        add(SignedInEvent(_user!));
      }
    }
  }

  void _termsRejectedEvent(TermsRejectedEvent event, Emitter emit) async {
    session.add(LogoutEvent());
  }

  void _termsAcceptedEvent(TermsAcceptedEvent event, Emitter emit) async {
    emit(InitCollaborateState());
  }

  void _collaborateMaybeLaterEvent(
      CollaborateMaybeLaterEvent event, Emitter emit) async {
    add(SignedInEvent(_user!));
  }

  void _collaborateFinishEvent(
      CollaborateFinishEvent event, Emitter emit) async {
    preferences.setFirstLogin();
    add(SignedInEvent(_user!));
  }

  User? getUser() => _user;

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }
}
