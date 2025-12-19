import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
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
