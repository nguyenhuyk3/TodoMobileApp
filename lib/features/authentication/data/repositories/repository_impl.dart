// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_mobile_app/features/authentication/domain/entities/user_registration.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/authentication_remote_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource _authenticationRemoteDataSource;

  AuthenticationRepositoryImpl({
    required AuthenticationRemoteDataSource authenticationRemoteDataSource,
  }) : _authenticationRemoteDataSource = authenticationRemoteDataSource;

  @override
  Future<Either<Failure, bool>> checkEmailExists({
    required String email,
  }) async {
    try {
      final exists = await _authenticationRemoteDataSource.checkEmailExists(
        email: email,
      );

      if (exists) {
        return Left(Failure(error: ErrorInformation.EMAIL_ALREADY_EXISTS));
      }

      return const Right(true);
    } catch (e) {
      return Left(Failure(error: ErrorInformation.UNDEFINED_ERROR, details: e));
    }
  }

  @override
  Future<Either<Failure, Object>> sendOTP({required String email}) async {
    try {
      await _authenticationRemoteDataSource.sendEmailOTP(email: email);

      return Right(Object());
    } on AuthException catch (e) {
      return Left(Failure(error: mapAuthException(e), details: e));
    } catch (e) {
      return Left(Failure(error: ErrorInformation.UNDEFINED_ERROR, details: e));
    }
  }

  @override
  Future<Either<Failure, Object>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      await _authenticationRemoteDataSource.verifyEmailOtp(
        email: email,
        otp: otp,
      );

      return Right(Object());
    } on AuthException catch (e) {
      return Left(Failure(error: mapAuthException(e), details: e));
    } catch (e) {
      return Left(Failure(error: ErrorInformation.UNDEFINED_ERROR, details: e));
    }
  }

  @override
  Future<Either<Failure, bool>> register(UserRegistrationEntity user) async {
    try {
      await _authenticationRemoteDataSource.register(user: user);

      return const Right(true);
    } on PostgrestException catch (e) {
      // LOGGER.e('PostgrestException: ${e.message}');

      return Left(Failure(error: mapPostgrestException(e), details: e));
    } on AuthException catch (e) {
      // LOGGER.e('AuthException: ${e.message}');

      return Left(Failure(error: mapAuthException(e), details: e));
    } catch (e) {
      // LOGGER.e('Undefined exception: $e');

      return Left(Failure(error: ErrorInformation.UNDEFINED_ERROR, details: e));
    }
  }
}
