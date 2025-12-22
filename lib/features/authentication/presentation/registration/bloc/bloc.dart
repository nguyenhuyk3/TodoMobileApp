import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todo_mobile_app/core/constants/others.dart';
import 'package:todo_mobile_app/features/authentication/domain/entities/extensions.dart';
import 'package:todo_mobile_app/features/authentication/domain/usecases/authentication_usecase.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/validator/validation_error_message.dart';
import '../../../domain/entities/user_registration.dart';
import '../../../inputs/email.dart';
import '../../../inputs/otp.dart';
import '../../../inputs/password.dart';

part 'event.dart';
part 'state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final CheckEmailExistsUseCase _checkEmailExistsUseCase;
  final SendOTPUseCase _sendOTPUseCase;
  final VerifyOTPUseCase _verifyOTPUseCase;
  final RegisterUseCase _registerUseCase;

  String _email = '';
  String _password = '';

  String get email => _email;

  RegistrationBloc({
    required CheckEmailExistsUseCase checkEmailExistsUseCase,
    required SendOTPUseCase sendOTPUseCase,
    required VerifyOTPUseCase verifyOTPUseCase,
    required RegisterUseCase registerUseCase,
  }) : _checkEmailExistsUseCase = checkEmailExistsUseCase,
       _sendOTPUseCase = sendOTPUseCase,
       _verifyOTPUseCase = verifyOTPUseCase,
       _registerUseCase = registerUseCase,

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

  // Step 1
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
      emit(currentState.copyWith(isLoading: true));
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
  // ========================== || ========================== //

  // Step 2
  Future<void> _onOtpChanged(
    RegistrationOtpChanged event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationStepTwo(otp: Otp.dirty(event.otp)));
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

      await Future.delayed(const Duration(seconds: 2));

      final verifyOTPResult = await _verifyOTPUseCase.execute(
        email: email,
        otp: currentState.otp.value,
      );
      verifyOTPResult.fold(
        (failure) {
          emit(RegistrationError(error: failure.message));
        },
        (_) {
          emit(
            RegistrationStepThree(
              password: Password.pure(),
              confirmedPassword: '',
              error: '',
            ),
          );
        },
      );
    }
  }
  // ========================== || ========================== //

  // Step 3
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

        emit(
          RegistrationStepFour(
            fullName: '',
            birthDate: BIRTH_DATE_DEFAUL_VALUE,
          ),
        );
      }
    }
  }
  // ========================== || ========================== //

  // Step 4
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

      // currentState.birthDate = YYYY-MM-DD, ex: 2000-01-20T00:00:00.000
      // DateTime.parse(currentState.birthDate) = YYYY-MM-DD 00:00:00.000, ex: 2000-01-20 00:00:00.000
      final userEntity = UserRegistrationEntity(
        email: _email,
        password: _password,
        fullName: currentState.fullName,
        dob: DateTime.parse(
          currentState.birthDate,
        ), // Convert String ISO -> DateTime
        sex: currentState.sex.toSex(),
        avatarUrl: null,
      );

      emit(currentState.copyWith(isLoading: true));

      final result = await _registerUseCase.execute(userEntity);

      await Future.delayed(const Duration(seconds: 2));

      result.fold(
        (failure) {
          emit(
            RegistrationStepFour(
              fullName: currentState.fullName,
              birthDate: currentState.birthDate,
              sex: currentState.sex,
              error: failure.message,
            ),
          );
        },
        (success) {
          emit(const RegistrationSuccess());
        },
      );
    }
  }
  // ========================== || ========================== //

  FutureOr<void> _onRegistrationReset(
    RegistrationReset event,
    Emitter<RegistrationState> emit,
  ) {
    emit(RegistrationInitial());
  }
}
