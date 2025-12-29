part of 'authentication_usecase.dart';

class LoginUseCase extends AuthenticationUsecase {
  LoginUseCase({required super.authenticationRepository});

  Future<Either<Failure, Object>> execute({
    required String email,
    required String password,
  }) {
    return _authenticationRepository.login(email: email, password: password);
  }
}
