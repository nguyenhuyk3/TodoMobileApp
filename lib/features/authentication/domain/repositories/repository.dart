import 'package:dartz/dartz.dart';
import 'package:todo_mobile_app/core/errors/failure.dart';

import '../entities/user_registration.dart';

/*
  dartz là functional programming library cho Dart
  Nó cung cấp các kiểu dữ liệu giúp: 
    - Tránh try-catch lộn xộn
    - Xử lý lỗi rõ ràng, an toàn
    - Code dễ test, dễ đọc
  Các kiểu hay dùng trong Flutter:
    - Either<L, R>
    - Option<T>
    - Unit
  Either là gì?
    - Either là kiểu dữ liệu chỉ có 1 trong 2 giá trị:
      + Left (L) → ❌ lỗi
      + Right (R) → ✅ thành công
    - 👉 Quy ước:
      + Left = Failure / Error
      + Right = Data / Success
*/
abstract class AuthenticationRepository {
  Future<Either<Failure, bool>> checkEmailExists({required String email});
  Future<Either<Failure, Object>> sendOTP({required String email});
  Future<Either<Failure, Object>> verifyOTP({
    required String email,
    required String otp,
  });
  Future<Either<Failure, bool>> register(UserRegistrationEntity user);
}
