// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:formz/formz.dart';

import '../../../core/constants/others.dart';


enum PasswordValidationError { empty, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }

    if (value.length < MINIMUM_LENGTH_FOR_PASSWORD) {
      return PasswordValidationError.tooShort;
    }

    return null;
  }
}
