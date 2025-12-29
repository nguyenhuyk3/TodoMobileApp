part of 'authentication_usecase.dart';

class CheckEmailExistsUseCase extends AuthenticationUsecase {
  CheckEmailExistsUseCase({required super.authenticationRepository});

  Future<Either<Failure, bool>> execute({required String email}) {
    return _authenticationRepository.checkEmailExists(email: email);
  }
}

class RegisterUseCase extends AuthenticationUsecase {
  RegisterUseCase({required super.authenticationRepository});

  Future<Either<Failure, bool>> execute(RegistrationParams params) {
    return _authenticationRepository.register(params);
  }
}
