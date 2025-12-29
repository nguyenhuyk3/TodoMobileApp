import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../entities/registration_params.dart';
import '../repositories/authentication.dart';

part 'registration_usecase.dart';
part 'forgot_password_usecasse.dart';
part 'login_usecase.dart';

abstract class AuthenticationUsecase {
  final AuthenticationRepository _authenticationRepository;

  // AuthenticationRepository get authenticationRepository =>
  //     _authenticationRepository;

  AuthenticationUsecase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;
}

class ResendOTPUseCase extends AuthenticationUsecase {
  ResendOTPUseCase({required super.authenticationRepository});

  Future<Either<Failure, bool>> execute({
    required String email,
    required OtpType type,
  }) {
    return _authenticationRepository.resendOTP(email: email, type: type);
  }
}

class VerifyOTPUseCase extends AuthenticationUsecase {
  VerifyOTPUseCase({required super.authenticationRepository});

  Future<Either<Failure, Object>> execute({
    required String email,
    required String otp,
    required OtpType type,
  }) {
    return _authenticationRepository.verifyOTP(
      email: email,
      otp: otp,
      type: type,
    );
  }
}
