// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/registration_remote_data_source.dart';

class RepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource _registrationLocalDataSource;

  RepositoryImpl({
    required RegistrationRemoteDataSource registrationLocalDataSource,
  }) : _registrationLocalDataSource = registrationLocalDataSource;

  @override
  Future<Either<Failure, Object>> sendRegistrationOTP({required String email}) {
    // TODO: implement sendRegistrationOTP
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> checkEmailExists({
    required String email,
  }) async {
    try {
      final exists = await _registrationLocalDataSource.checkEmailExists(
        email: email,
      );

      return exists
          ? const Right(true)
          : Left(Failure(error: ErrorInformation.EMAIL_NOT_EXISTS));
    } catch (e) {
      return Left(Failure(error: ErrorInformation.UNDEFINED_ERROR, details: e));
    }
  }
}
