import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todo_mobile_app/features/authentication/domain/usecases/authentication_use_case.dart';

import '../../../../../core/utils/validator/validation_error_message.dart';
import '../../../inputs/email.dart';
import '../../../inputs/password.dart';

part 'event.dart';
part 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const LoginState()) {
    on<LoginEmailChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onUsernameChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(email: Email.dirty(event.email), error: state.error));
  }

  FutureOr<void> _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: Password.dirty(event.password),
        error: state.error,
      ),
    );
  }

  FutureOr<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final emailError = ValidationErrorMessage.getEmailErrorMessage(
      error: state.email.error,
    );

    if (emailError != null) {
      emit(
        state.copyWith(
          email: state.email,
          password: state.password,
          error: emailError,
        ),
      );

      return;
    }

    final passwordError = ValidationErrorMessage.getPasswordErrorMessage(
      error: state.password.error,
    );

    if (passwordError != null) {
      emit(
        state.copyWith(
          email: state.email,
          password: state.password,
          error: passwordError,
        ),
      );

      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final res = await _loginUseCase.execute(
      email: state.email.value,
      password: state.password.value,
    );

    res.fold((failure) {}, (data) {});

    // if (state.email.value == '1notthingm@gmail.com' &&
    //     state.password.value == '12345678') {
    //   await Future.delayed(const Duration(seconds: 2));

    //   emit(state.copyWith(status: FormzSubmissionStatus.success));

    //   return;
    // } else {
    //   await Future.delayed(const Duration(seconds: 2));

    //   emit(
    //     state.copyWith(
    //       status: FormzSubmissionStatus.failure,
    //       error: 'Email hoặc mật khẩu không đúng',
    //     ),
    //   );

    //   return;
    // }
  }
}
