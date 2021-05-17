import 'package:bloc/bloc.dart';
import 'package:yodravet/src/model/signup.dart';

import 'event/signup_event.dart';
import 'interface/session_interface.dart';
import 'state/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  Signup _signup = Signup();
  Session session;
  bool _isLoading = false;

  SignupBloc(this.session);

  @override
  SignupState get initialState => SignupInitState();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignUpEvent) {
      try {
        _signup.email = event.email;
        _signup.name = event.name;
        _signup.lastname = event.lastname;
        _signup.password = event.password;
        _signup.passwordCopy = event.passwordCopy;

        _signup.cleanErrors();
        _signup.validateFields();

        if(_signup.existsError) {
          yield _updateSignupFieldsState();
        } else {
          _isLoading = true;
          yield _updateSignupFieldsState();
          await this.session.signup(_signup.email, _signup.password, _signup.name, _signup.lastname, _signup.photo);
          _isLoading = false;
          yield SignUpSuccessState();
        }
      } catch (error) {
        yield error is SignupStateError
            ? SignupStateError(error.message)
            : SignupStateError('Algo fue mal al registrarte!');
      }
    }
  }

  SignupState _updateSignupFieldsState() {
    return UpdateSignupFieldsState(signup: _signup, isLoading: _isLoading, showError: false);
  }
}
