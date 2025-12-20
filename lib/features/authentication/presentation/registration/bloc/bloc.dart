import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todo_mobile_app/core/constants/others.dart';
import 'package:todo_mobile_app/features/authentication/domain/usecases/authentication_usecase.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/validator/validation_error_message.dart';
import '../../../inputs/email.dart';
import '../../../inputs/otp.dart';
import '../../../inputs/password.dart';

part 'event.dart';
part 'state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final CheckEmailExistsUseCase _checkEmailExistsUseCase;
  final SendOTPUseCase _sendOTPUseCase;
  final VerifyOTPUseCase _verifyOTPUseCase;

  String _email = '';
  String _password = '';

  String get email => _email;

  RegistrationBloc({
    required CheckEmailExistsUseCase checkEmailExistsUseCase,
    required SendOTPUseCase sendOTPUseCase,
    required VerifyOTPUseCase verifyOTPUseCase,
  }) : _checkEmailExistsUseCase = checkEmailExistsUseCase,
       _sendOTPUseCase = sendOTPUseCase,
       _verifyOTPUseCase = verifyOTPUseCase,

       super(RegistrationInitial()) {
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationEmailSubmitted>(_onEmailSubmitted);

    on<RegistrationOtpChanged>(_onOtpChanged);
    on<RegistrationResendOTPRequested>(_onResendOTPRequested);
    on<RegistrationOtpSubmitted>(_onOtpSubmitted);

    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationPasswordSubmitted>(_onPasswordSubmitted);
    on<RegistrationInformationChanged>(_onInformationChanged);
    on<RegistrationSubmitted>(_onRegistrationSubmitted);
    on<RegistrationReset>(_onRegistrationReset);
  }

  Future<void> _onEmailChanged(
    RegistrationEmailChanged event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationStepOne(email: Email.dirty(event.email)));
  }

  FutureOr<void> _onEmailSubmitted(
    RegistrationEmailSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    final currentState = state;

    if (currentState is RegistrationStepOne) {
      // 1. KIỂM TRA VALIDATION (CLIENT SIDE)
      final error = ValidationErrorMessage.getEmailErrorMessage(
        error: currentState.email.error,
      );

      if (error != null) {
        emit(RegistrationError(error: error));

        return;
      }
      // 2. CHUẨN BỊ DỮ LIỆU
      _email = currentState.email.value;
      // 3. BẬT TRẠNG THÁI LOADING
      emit(const RegistrationLoading());
      // Giả lập thời gian chờ (Có thể xóa khi dùng thật)
      await Future.delayed(const Duration(seconds: 2));
      // 4. GỌI API KIỂM TRA EMAIL TRÊN SERVER
      final isEmailExists = await _checkEmailExistsUseCase.execute(
        email: currentState.email.value,
      );
      // Thay vì dùng fold lồng nhau, ta dùng pattern matching hoặc biến trung gian
      // Ở đây dùng await để xử lý tuần tự:
      final isEmailExistsResult = isEmailExists.fold((l) => l, (r) => r);

      if (isEmailExistsResult is Failure) {
        emit(RegistrationError(error: isEmailExistsResult.message));

        return;
      }

      final sendOtpResult = await _sendOTPUseCase.execute(email: _email);

      sendOtpResult.fold(
        (failure) {
          emit(RegistrationError(error: failure.message));
        },
        (_) {
          emit(RegistrationStepTwo(otp: const Otp.pure()));
        },
      );
    }
  }

  Future<void> _onOtpChanged(
    RegistrationOtpChanged event,
    Emitter<RegistrationState> emit,
  ) async {
    if (event.otp.length == LENGTH_OF_OTP) {
      // final verifyOTPResult = await _verifyOTPUseCase.execute(
      //   email: email,
      //   otp: event.otp,
      // );

      // verifyOTPResult.fold(
      //   (failure) {
      //     emit(RegistrationStepTwo(otp: Otp.dirty(event.otp)));
      //   },
      //   (_) {
      //     emit(RegistrationStepOne(email: Email.dirty('')));
      //   },
      // );

      if (event.otp == '111111') {
        emit(RegistrationStepOne(email: Email.dirty('')));
      }
    }
  }

  FutureOr<void> _onResendOTPRequested(
    RegistrationResendOTPRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    final currentState = state;

    if (currentState is RegistrationStepTwo) {
      final sendOTResult = await _sendOTPUseCase.execute(email: _email);

      sendOTResult.fold(
        (failure) {
          emit(RegistrationError(error: failure.message));
        },
        (_) {
          emit(RegistrationStepTwo(otp: Otp.dirty(currentState.otp.value)));
        },
      );
    }
  }

  FutureOr<void> _onOtpSubmitted(
    RegistrationOtpSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    final currentState = state;

    if (currentState is RegistrationStepTwo) {
      final error = ValidationErrorMessage.getOtpErrorMessage(
        error: currentState.otp.error,
      );

      if (error != null) {
        emit(RegistrationError(error: error));

        return;
      }

      emit(const RegistrationLoading());

      await Future.delayed(const Duration(seconds: 1));

      final verifyOTPResult = await _verifyOTPUseCase.execute(
        email: email,
        otp: currentState.otp.value,
      );
      verifyOTPResult.fold(
        (failure) {
          emit(RegistrationStepTwo(otp: Otp.dirty(currentState.otp.value)));
        },
        (_) {
          // Emit next state
        },
      );
    }
  }

  Future<void> _onPasswordChanged(
    RegistrationPasswordChanged event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(
      RegistrationStepThree(
        password: Password.dirty(event.password),
        confirmedPassword: event.confirmedPassword,
        error: '',
      ),
    );
  }

  Future<void> _onPasswordSubmitted(
    RegistrationPasswordSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    final currentState = state;

    if (currentState is RegistrationStepThree) {
      final password = currentState.password;
      final error = ValidationErrorMessage.getPasswordErrorMessage(
        error: password.error,
      );

      if (error != null) {
        emit(
          RegistrationStepThree(
            password: password,
            confirmedPassword: currentState.confirmedPassword,
            error: error,
          ),
        );

        return;
      }

      if (currentState.confirmedPassword.isEmpty) {
        emit(
          RegistrationStepThree(
            password: password,
            confirmedPassword: currentState.confirmedPassword,
            error: ErrorInformation.EMPTY_CONFIRMED_PASSWORD.message,
          ),
        );

        return;
      }

      if (currentState.password.value != currentState.confirmedPassword) {
        emit(
          RegistrationStepThree(
            password: password,
            confirmedPassword: currentState.confirmedPassword,
            error: ErrorInformation.CONFIRMED_PASSWORD_MISSMATCH.message,
          ),
        );
      } else {
        _password = currentState.password.value;

        emit(RegistrationStepFour(fullName: '', birthDate: ''));
      }
    }
  }

  Future<void> _onInformationChanged(
    RegistrationInformationChanged event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(
      RegistrationStepFour(
        fullName: event.fullName,
        birthDate: event.formattedBirthDate,
        sex: event.sex,
      ),
    );
  }

  Future<void> _onRegistrationSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    final currentState = state;

    if (currentState is RegistrationStepFour) {
      if (currentState.fullName.isEmpty) {
        emit(
          RegistrationStepFour(
            fullName: currentState.fullName,
            birthDate: currentState.birthDate,
            sex: currentState.sex,
            error: ErrorInformation.EMPTY_FULL_NAME.message,
          ),
        );

        return;
      }
    }
  }

  FutureOr<void> _onRegistrationReset(
    RegistrationReset event,
    Emitter<RegistrationState> emit,
  ) {
    emit(RegistrationInitial());
  }
}
