import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/repository/interface/preferences.dart';
import 'package:yodravet/src/shared/platform_discover.dart';

import 'event/auth_event.dart';
import 'event/session_event.dart' as sessionEvent;
import 'event/session_event.dart';
import 'interface/session_interface.dart';
import 'state/auth_state.dart';
import 'state/session_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  User _user = User();
  Preferences preferences;
  Session session;

  AuthBloc(this.preferences, this.session) {
    this.session.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          this._user = this.session.user;
          this.add(SignedInEvent(this._user));
        } else {
          this.add(LogOutSuccessEvent());
        }
      } else if (state is LogOutState) {
        this.add(LogOutSuccessEvent());
      } else if (state is UserChangeState) {
        this._user = state.user;
      }
    });
  }

  @override
  AuthState get initialState => AuthInitState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthEventEmpty) {
      yield AuthInitState();
    } else if (event is AutoLogInEvent) {
      try {
        await _autoLogin(this.session, preferences);
      } catch (error) {
        yield error is AuthStateError
            ? AuthStateError(error.message)
            : AuthStateError('Algo fue mal en el AutoLogIn!');
      }
    } else if (event is LogInEvent) {
      try {
        yield AuthLoadingState(isLoading: true);
        try {
          this._user = await this.session.logIn(event.email, event.pass);
        } catch (error) {
          throw AuthStateError(error.message);
        }
      } catch (error) {
        yield error is AuthStateError
            ? AuthStateError(error.message)
            : AuthStateError('Algo fue mal en el LogIn!');
      }
    } else if (event is GoogleLogInEvent) {
      try {
        yield AuthLoadingState(isLoadingGoogle: true);
        try {
          this._user = await this.session.googleLogIn();
        } catch (error) {
          throw error is auth.FirebaseAuthException ?
           AuthStateError(error.message) :
           AuthStateError(error.message);
        }
      } catch (error) {
        yield error is AuthStateError
            ? AuthStateError(error.message)
            : AuthStateError('Algo fue mal en el LogIn de Google!');
      }
    } else if (event is AppleLogInEvent) {
      try {
        yield AuthLoadingState(isLoadingApple: true);
        try {
          this._user = await this.session.appleLogIn();
        } catch (error) {
          throw error is auth.FirebaseAuthException ?
           AuthStateError(error.message) :
           AuthStateError(error.message);
        }
      } catch (error) {
        yield error is AuthStateError
            ? AuthStateError(error.message)
            : AuthStateError('Algo fue mal en el LogIn de Apple!');
      }
    } else if (event is StravaLogInEvent) {
      try {
        // yield AuthLoadingState();
        try {
          if (!PlatformDiscover.isWeb()) {
            this._user.isStravaLogin = await this.session.stravaLogIn();
          }
          this.session.add(UserChangeEvent(this._user));
        } catch (error) {
          throw AuthStateError(error.message);
        }
      } catch (error) {
        yield error is AuthStateError
            ? AuthStateError(error.message)
            : AuthStateError('Algo fue mal en el LogIn de Strava!');
      }
    } else if (event is LogOutEvent) {
      try {
        if(this._user.isLogin) {
          this.preferences.logout();
          this.session.add(sessionEvent.LogoutEvent());
        }
      } catch (error) {
        yield error is AuthStateError
            ? AuthStateError(error.message)
            : AuthStateError('Algo fue mal en al cerrar la sessi??n!');
      }
    } else if (event is LogOutSuccessEvent) {
      yield LogOutSuccessState();
    } else if (event is SignedInEvent) {
      try {
        _keepUser(this.preferences, this._user, this.session.password);
        yield LogInSuccessState(this._user);
      } catch (error) {
        yield error is AuthStateError
            ? AuthStateError(error.message)
            : AuthStateError('Algo fue mal en al cerrar la sessi??n!');
      }
    } else if (event is ChangePasswordEvent) {
      try {
        if(event.email.isEmpty) {
          throw AuthStateError('Por favor rellenar campo usuario con su correo electr??nico');
        }
        if (await this.session.changePassword(event.email)) {
          this.add(LogOutEvent());
          yield ChangePasswordSuccessState(this._user);
        }
      } catch (error) {
        yield error is AuthStateError
            ? AuthStateError(error.message)
            : AuthStateError('Algo fue mal en el cambio de contrase??a!');
      }
    } else if (event is Go2SignupEvent) {
      yield Go2SignupState();
    }
  }

  _autoLogin(Session session, Preferences preferences) async {
    String userEmail = '';
    String password = '';

    print('Estoy en autologin en auth_bloc');
    userEmail = preferences.getString('userEmail');
    password = preferences.getString('password');

    await session.autoLogIn(userEmail, password);

    print('Salgo de autologin en auth_bloc');
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
}
