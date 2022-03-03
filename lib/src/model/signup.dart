import 'package:email_validator/email_validator.dart';
import 'package:yodravet/src/model/user.dart';

class Signup extends User {
  String? password;
  String? passwordCopy;

  String? emailError;
  String? nameError;
  String? lastnameError;
  String? passwordError;
  String? passwordCopyError;

  get existsError => emailError!.isNotEmpty ||
          nameError!.isNotEmpty ||
          lastnameError!.isNotEmpty ||
          passwordError!.isNotEmpty ||
          passwordCopyError!.isNotEmpty
      ? true
      : false;

  void cleanErrors() {
    emailError = '';
    nameError = '';
    lastnameError = '';
    passwordError = '';
    passwordCopyError = '';
  }

  void validateFields() {
    emailError = _validateEmptyField(email);
    nameError = _validateEmptyField(name);
    lastnameError = _validateEmptyField(lastname);
    passwordError = _validateEmptyField(password);
    passwordCopyError = _validateEmptyField(passwordCopy);
    if (emailError!.isEmpty) {
      emailError = _validateEmail(email!);
    }
    if (passwordError!.isEmpty) {
      passwordError = _validatePassword(password!);
    }
    if (passwordCopyError!.isEmpty) {
      passwordCopyError = _validateEqualPasswords(password, passwordCopy);
    }
  }

  String _validateEmail(String email) {
    String emailError = '';

    if (email.isNotEmpty) {
      if (!EmailValidator.validate(email)) {
        emailError = 'Formato correo erróneo';
      }
    }

    return emailError;
  }

  String _validateEmptyField(String? value) {
    String errorMessage = '';

    if (value == null || value.isEmpty) {
      errorMessage = 'El campo no puede estar vacío';
    }

    return errorMessage;
  }

  String _validatePassword(String password) {
    String passwordError = '';

    if (password.length < 6) {
      passwordError = 'La contraseña debe tener mayor a 6 caracteres';
    }

    return passwordError;
  }

  String _validateEqualPasswords(String? password, String? passwordCopy) {
    String passwordCopyError = '';

    if (passwordError!.isEmpty && passwordCopyError.isEmpty) {
      if (password!.compareTo(passwordCopy!) != 0) {
        passwordCopyError = 'Las contraseñas no son iguales';
      }
    }

    return passwordCopyError;
  }
}
