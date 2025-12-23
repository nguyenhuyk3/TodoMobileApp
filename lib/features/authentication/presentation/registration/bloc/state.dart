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

/*

*/

// Nếu như state này được sử dụng trước khi chuyển sang step tiếp theo
// Thì nên có thêm trường isLoading để biểu thị trạng thái loading khi submit
// Tránh sử dụng chung với RegistrationLoading vì nó sẽ làm mất trạng thái của các field input
class RegistrationStepOne extends RegistrationState {
  final Email email;
  final bool isLoading;

  const RegistrationStepOne({
    required this.email,
    this.isLoading = false,
  }) : super(status: FormzSubmissionStatus.inProgress);

  RegistrationStepOne copyWith({
    Email? email,
    bool? isLoading,
  }) {
    return RegistrationStepOne(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [email, isLoading, status];
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
  // Nếu trạng thái này mà còn chứa những field khác ngoài input thôi thì phải cần thêm trường này
  final bool isLoading;

  const RegistrationStepFour({
    required this.fullName,
    required this.birthDate,
    this.sex = 'male',
    this.error = '',
    this.isLoading = false,
  }) : super(status: FormzSubmissionStatus.inProgress);

  @override
  List<Object?> get props => [fullName, birthDate, sex, error, isLoading];

  RegistrationStepFour copyWith({
    String? fullName,
    String? birthDate,
    String? sex,
    String? error,
    bool? isLoading,
  }) {
    return RegistrationStepFour(
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
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
