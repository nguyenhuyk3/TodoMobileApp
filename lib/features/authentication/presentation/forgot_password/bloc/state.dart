part of 'bloc.dart';

sealed class ForgotPasswordState extends Equatable {
  final FormzSubmissionStatus status;

  const ForgotPasswordState({required this.status});

  @override
  List<Object?> get props => [status];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial() : super(status: FormzSubmissionStatus.initial);
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading()
    : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [];
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;

  const ForgotPasswordError({required this.error})
    : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [error];
}

class ForgotPasswordStepOne extends ForgotPasswordState {
  final Email email;

  const ForgotPasswordStepOne({required this.email})
    : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordStepTwo extends ForgotPasswordState {
  final Otp otp;

  const ForgotPasswordStepTwo({required this.otp})
    : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [otp];
}

class ForgotPasswordStepThree extends ForgotPasswordState {
  final Password password;
  final String confirmedPassword;
  final String error;

  const ForgotPasswordStepThree({
    required this.password,
    required this.confirmedPassword,
    required this.error,
  }) : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [password, confirmedPassword, error];
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess() : super(status: FormzSubmissionStatus.success);
}
