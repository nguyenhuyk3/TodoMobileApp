import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
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

  String _email = '';
  String _password = '';

  String get email => _email;

  RegistrationBloc({required CheckEmailExistsUseCase checkEmailExistsUseCase})
    : _checkEmailExistsUseCase = checkEmailExistsUseCase,
      super(RegistrationInitial()) {
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationEmailSubmitted>(_onEmailSubmitted);
    on<RegistrationOtpChanged>(_onOtpChanged);
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
    // Lấy trạng thái hiện tại để truy cập vào giá trị email
    final currentState = state;

    if (currentState is RegistrationStepOne) {
      // 1. KIỂM TRA VALIDATION (CLIENT SIDE)
      // Nếu người dùng chưa nhập hoặc nhập sai định dạng email
      final error = ValidationErrorMessage.getEmailErrorMessage(
        error: currentState.email.error,
      );

      if (error != null) {
        // Phát ra lỗi và kết thúc sớm (return) để không gọi API tốn tài nguyên
        emit(RegistrationError(error: error));

        return;
      }
      // 2. CHUẨN BỊ DỮ LIỆU
      _email =
          currentState.email.value; // Lưu vào biến cục bộ để dùng cho bước OTP
      // 3. BẬT TRẠNG THÁI LOADING
      emit(const RegistrationLoading());
      // Giả lập thời gian chờ (Có thể xóa khi dùng thật)
      await Future.delayed(const Duration(seconds: 2));
      // 4. GỌI API KIỂM TRA EMAIL TRÊN SERVER
      final isEmailExists = await _checkEmailExistsUseCase.excute(
        email: currentState.email.value,
      );
      // 5. XỬ LÝ KẾT QUẢ TỪ REPOSITORY (Sử dụng fold cho dartz/fpdart)
      isEmailExists.fold(
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
    emit(RegistrationStepTwo(otp: Otp.dirty(event.otp)));
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
