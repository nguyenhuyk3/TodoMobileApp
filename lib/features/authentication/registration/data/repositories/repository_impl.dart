// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:todo_mobile_app/core/errors/failure.dart';
import 'package:todo_mobile_app/features/authentication/registration/data/datasources/registration_local_data_source.dart';

import '../../domain/repositories/repository.dart';

class RepositoryImpl implements RegistrationRepository {
  final RegistrationLocalDataSource registrationLocalDataSource;

  RepositoryImpl({required this.registrationLocalDataSource});

  @override
  Future<Either<Failure, Object>> sendRegistrationOTP({required String email}) {
    // TODO: implement sendRegistrationOTP
    throw UnimplementedError();
  }
}
  