import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_registration.dart';
import '../repositories/repository.dart';

part 'registration_usecase.dart';

abstract class AuthenticationUsecase {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationRepository get authenticationRepository =>
      _authenticationRepository;

  AuthenticationUsecase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;
}

class SendOTPUseCase extends AuthenticationUsecase {
  SendOTPUseCase({required super.authenticationRepository});

  Future<Either<Failure, Object>> execute({required String email}) {
    return authenticationRepository.sendOTP(email: email);
  }
}

class VerifyOTPUseCase extends AuthenticationUsecase {
  VerifyOTPUseCase({required super.authenticationRepository});

  Future<Either<Failure, Object>> execute({
    required String email,
    required String otp,
  }) {
    return authenticationRepository.verifyOTP(email: email, otp: otp);
  }
}
