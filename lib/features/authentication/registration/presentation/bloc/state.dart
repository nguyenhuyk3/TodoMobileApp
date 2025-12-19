part of 'bloc.dart';

sealed class RegistrationState extends Equatable {
  final FormzSubmissionStatus status;

  const RegistrationState({required this.status});

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial() : super(status: FormzSubmissionStatus.initial);
}

class RegistrationLoading extends RegistrationState {
  const RegistrationLoading() : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [];
}

class RegistrationStepOne extends RegistrationState {
  final Email email;

  const RegistrationStepOne({required this.email})
    : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [email];
}

class RegistrationStepTwo extends RegistrationState {
  final Otp otp;

  const RegistrationStepTwo({required this.otp})
    : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [otp];
}

class RegistrationStepThree extends RegistrationState {
  final Password password;
  final String confirmedPassword;
  final String error;

  const RegistrationStepThree({
    required this.password,
    required this.confirmedPassword,
    required this.error,
  }) : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [password, confirmedPassword, error];
}

class RegistrationStepFour extends RegistrationState {
  final String fullName;
  final String birthDate;
  final String sex;
  final String error;

  const RegistrationStepFour({
    required this.fullName,
    required this.birthDate,
    this.sex = 'male',
    this.error = '',
  }) : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [fullName, birthDate, sex, error];
}

// If other classes only have one attribute, this class will be used with that class.
class RegistrationError extends RegistrationState {
  final String error;

  const RegistrationError({required this.error})
    : super(status: FormzSubmissionStatus.failure);

  @override
  List<Object?> get props => [error];
}

class RegistrationSuccess extends RegistrationState {
  const RegistrationSuccess() : super(status: FormzSubmissionStatus.success);
}
