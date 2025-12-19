part of 'authentication_usecase.dart';

class CheckEmailExistsUseCase extends AuthenticationUsecase {
  CheckEmailExistsUseCase({required super.authenticationRepository});

  Future<Either<Failure, bool>> excute({required String email}) {
    return authenticationRepository.checkEmailExists(email: email);
  }
}

class SendRegistrationOTPUseCase extends AuthenticationUsecase {
  SendRegistrationOTPUseCase({required super.authenticationRepository});

  Future<Either<Failure, Object>> excute({required String email}) {
    return authenticationRepository.sendRegistrationOTP(email: email);
  }
}
