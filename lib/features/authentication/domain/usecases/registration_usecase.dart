part of 'authentication_usecase.dart';

class CheckEmailExistsUseCase extends AuthenticationUsecase {
  CheckEmailExistsUseCase({required super.authenticationRepository});

  Future<Either<Failure, bool>> execute({required String email}) {
    return authenticationRepository.checkEmailExists(email: email);
  }
}
