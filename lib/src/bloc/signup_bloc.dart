import 'package:bloc/bloc.dart';
import 'package:yodravet/src/model/signup.dart';

import 'event/signup_event.dart';
import 'interface/session_interface.dart';
import 'state/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final Signup _signup = Signup();
  Session session;
  bool _isLoading = false;

  SignupBloc(this.session) : super(SignupInitState()) {
    on<SignupEventEmpty>((event, emit) => emit(SignupInitState()));
    on<SignUpEvent>(_signUpEvent);
  }

  void _signUpEvent(SignUpEvent event, Emitter emit) async {
    try {
      _signup.email = event.email;
      _signup.name = event.name;
      _signup.lastname = event.lastname;
      _signup.password = event.password;
      _signup.passwordCopy = event.passwordCopy;

      _signup.cleanErrors();
      _signup.validateFields();

      if (_signup.existsError) {
        emit(_updateSignupFieldsState());
      } else {
        _isLoading = true;
        emit(_updateSignupFieldsState());
        await session.signup(_signup.email, _signup.password, _signup.name,
            _signup.lastname, _signup.photo);
        _isLoading = false;
        emit(SignUpSuccessState());
      }
    } catch (error) {
      emit(error is SignupStateError
          ? SignupStateError(error.message)
          : SignupStateError('Algo fue mal al registrarte!'));
    }
  }

  SignupState _updateSignupFieldsState() => UpdateSignupFieldsState(
        signup: _signup, isLoading: _isLoading, showError: false);
}
