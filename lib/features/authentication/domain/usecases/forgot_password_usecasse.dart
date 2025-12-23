part of 'authentication_usecase.dart';

class UpdatePasswordUseCase extends AuthenticationUsecase {
  UpdatePasswordUseCase({required super.authenticationRepository});

  Future<Either<Failure, bool>> execute({
    required String email,
    required String newPassword,
  }) {
    return authenticationRepository.updatePassword(
      email: email,
      newPassword: newPassword,
    );
  }
}
