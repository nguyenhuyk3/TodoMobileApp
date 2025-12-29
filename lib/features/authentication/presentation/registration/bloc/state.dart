part of 'bloc.dart';

sealed class RegistrationState extends Equatable {
  final FormzSubmissionStatus status;

  const RegistrationState({required this.status});

  @override
  List<Object?> get props => [status];
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial() : super(status: FormzSubmissionStatus.initial);
}

// Step 1
class RegistrationStepOne extends RegistrationState {
  final Email email;
  final Password password;
  final String confirmedPassword;
  final String fullName;
  final String birthDate;
  final String sex;
  final String error;
  final bool isLoading;

  const RegistrationStepOne({
    required this.email,
    required this.password,
    required this.confirmedPassword,
    required this.fullName,
    this.birthDate = BIRTH_DATE_DEFAUL_VALUE,
    required this.sex,
    required this.error,
    required this.isLoading,
  }) : super(status: FormzSubmissionStatus.inProgress);

  factory RegistrationStepOne.initial() {
    return RegistrationStepOne(
      email: Email.pure(),
      password: Password.pure(),
      confirmedPassword: '',
      fullName: '',
      birthDate: BIRTH_DATE_DEFAUL_VALUE,
      sex: 'male',
      error: '',
      isLoading: false,
    );
  }

  RegistrationStepOne copyWith({
    Email? email,
    Password? password,
    String? confirmedPassword,
    String? fullName,
    String? birthDate,
    String? sex,
    String? error,
    bool? isLoading,
  }) {
    return RegistrationStepOne(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    confirmedPassword,
    fullName,
    birthDate,
    sex,
    error,
    isLoading,
  ];
}
// ========================== || ========================== //

// Step 2
class RegistrationStepTwo extends RegistrationState {
  final Otp otp;
  final String error;
  final bool isLoading;

  const RegistrationStepTwo({
    required this.otp,
    this.error = '',
    this.isLoading = false,
    FormzSubmissionStatus status = FormzSubmissionStatus.inProgress,
  }) : super(status: status);

  factory RegistrationStepTwo.initial() {
    return const RegistrationStepTwo(
      otp: Otp.pure(),
      status: FormzSubmissionStatus.initial,
    );
  }

  RegistrationStepTwo copyWith({
    Otp? otp,
    String? error,
    bool? isLoading,
    FormzSubmissionStatus? status,
  }) {
    return RegistrationStepTwo(
      otp: otp ?? this.otp,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [otp, error, isLoading, status];
}
// ========================== || ========================== //

class RegistrationSuccess extends RegistrationState {
  const RegistrationSuccess() : super(status: FormzSubmissionStatus.success);
}
