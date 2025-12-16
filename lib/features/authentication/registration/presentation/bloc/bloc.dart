import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/validator/validation_error_message.dart';
import '../../../inputs/email.dart';
import '../../../inputs/otp.dart';
import '../../../inputs/password.dart';
import '../../domain/repositories/repository.dart';

part 'event.dart';
part 'state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegistrationRepository _registrationRepository;

  String _email = '';
  String _password = '';

  RegistrationBloc({required RegistrationRepository registrationRepository})
    : _registrationRepository = registrationRepository,
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
    final currentState = state;

    if (currentState is RegistrationStepOne) {
      final error = ValidationErrorMessage.getEmailErrorMessage(
        error: currentState.email.error,
      );

      if (error != null) {
        emit(RegistrationError(error: error));

        return;
      }

      final isEmailExists = await _registrationRepository.checkEmailExists(
        email: currentState.email.value,
      );

      isEmailExists.fold(
        (failure) {
          emit(RegistrationError(error: failure.message));
        },
        (exists) {
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
