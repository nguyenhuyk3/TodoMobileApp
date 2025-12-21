import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../../core/constants/errors.dart';
import '../../../../../core/constants/others.dart';
import '../../../../../core/utils/validator/validation_error_message.dart';
import '../../../inputs/email.dart';
import '../../../inputs/otp.dart';
import '../../../inputs/password.dart';

part 'event.dart';
part 'state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  String _email = '';

  String get email => _email;

  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailChanged>(_onForgotPasswordChanged);
    on<ForgotPasswordEmailSubmitted>(_onEmailSubmitted);

    on<ForgotPasswordOtpChanged>(_onOtpChanged);
    on<ForgotPasswordResendOTPRequested>(_onResendOTPRequested);
    on<ForgotPasswordOtpSubmitted>(_onOtpSubmitted);

    on<ForgotPasswordPasswordChanged>(_onPasswordChanged);
    on<ForgotPasswordSubmitted>(_onPasswordSubmmitted);
  }

  // Step 1
  FutureOr<void> _onForgotPasswordChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(ForgotPasswordStepOne(email: Email.dirty(event.email)));
  }

  FutureOr<void> _onEmailSubmitted(
    ForgotPasswordEmailSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final currentState = state;

    if (currentState is ForgotPasswordStepOne) {
      if (currentState.email.value == 'abc@gmail.com' ||
          currentState.email.value == 'huy2@gmail.com') {
        emit(ForgotPasswordLoading());

        await Future.delayed(const Duration(seconds: 2));

        emit(ForgotPasswordError(error: 'Email không tồn tại!!'));

        return;
      }

      _email = currentState.email.value;

      emit(ForgotPasswordLoading());

      final error = ValidationErrorMessage.getEmailErrorMessage(
        error: currentState.email.error,
      );

      await Future.delayed(const Duration(seconds: 2));

      if (error != null) {
        emit(ForgotPasswordError(error: error));
      } else {
        emit(ForgotPasswordStepTwo(otp: Otp.pure()));
      }
    }
  }

  // ==========================  || ========================== //

  // Step 2
  FutureOr<void> _onOtpChanged(
    ForgotPasswordOtpChanged event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (event.otp.length == LENGTH_OF_OTP) {
      if (event.otp == '111111') {
        emit(ForgotPasswordLoading());

        await Future.delayed(const Duration(seconds: 2));

        emit(
          ForgotPasswordStepThree(
            password: const Password.pure(),
            confirmedPassword: '',
            error: '',
          ),
        );

        return;
      }
    }

    emit(ForgotPasswordStepTwo(otp: Otp.dirty(event.otp)));
  }

  FutureOr<void> _onResendOTPRequested(
    ForgotPasswordResendOTPRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final currentState = state;

    if (currentState is ForgotPasswordStepTwo) {
      emit(ForgotPasswordStepTwo(otp: Otp.dirty(currentState.otp.value)));
    }
  }

  FutureOr<void> _onOtpSubmitted(
    ForgotPasswordOtpSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final currentState = state;

    if (currentState is ForgotPasswordStepTwo) {
      if (currentState.otp.value == '123456' ||
          currentState.otp.value == '23456') {
        emit(ForgotPasswordError(error: 'Mã OTP không đúng!!'));

        return;
      }

      final error = ValidationErrorMessage.getOtpErrorMessage(
        error: currentState.otp.error,
      );

      if (error != null) {
        emit(ForgotPasswordError(error: error));

        return;
      } else {
        emit(
          ForgotPasswordStepThree(
            password: const Password.pure(),
            confirmedPassword: '',
            error: '',
          ),
        );
      }
    }
  }

  // ========================== || ========================== //

  // Step 3
  FutureOr<void> _onPasswordChanged(
    ForgotPasswordPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      ForgotPasswordStepThree(
        password: Password.dirty(event.password),
        confirmedPassword: event.confirmedPassword,
        error: '',
      ),
    );
  }

  FutureOr<void> _onPasswordSubmmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final currentState = state;

    LOGGER.i(currentState);

    if (currentState is ForgotPasswordStepThree) {
      final password = currentState.password;
      final error = ValidationErrorMessage.getPasswordErrorMessage(
        error: password.error,
      );

      if (error != null) {
        emit(
          ForgotPasswordStepThree(
            password: password,
            confirmedPassword: currentState.confirmedPassword,
            error: error,
          ),
        );

        return;
      }

      if (currentState.confirmedPassword.isEmpty) {
        emit(
          ForgotPasswordStepThree(
            password: password,
            confirmedPassword: currentState.confirmedPassword,
            error: EMPTY_CONFIRMED_PASSWORD_ERROR,
          ),
        );

        return;
      }

      if (currentState.password.value != currentState.confirmedPassword) {
        LOGGER.i(1);
        emit(
          ForgotPasswordStepThree(
            password: password,
            confirmedPassword: currentState.confirmedPassword,
            error: CONFIRMED_PASSWORD_MISMATCH_ERROR,
          ),
        );
      } else {
        LOGGER.i(2);
        emit(ForgotPasswordLoading());

        await Future.delayed(const Duration(seconds: 2));

        emit(const ForgotPasswordSuccess());
      }
    }
  }

  // ========================== || ========================== //
}
