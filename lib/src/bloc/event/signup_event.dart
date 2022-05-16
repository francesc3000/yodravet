abstract class SignupEvent {}

class SignupEventEmpty extends SignupEvent {
  @override
  String toString() => 'Empty Event';
}

class SignUpEvent extends SignupEvent {
  final String email;
  final String name;
  final String lastname;
  final String password;
  final String passwordCopy;

  SignUpEvent(
      this.email, this.name, this.lastname, this.password, this.passwordCopy);

  @override
  String toString() => 'SignUp Event';
}
