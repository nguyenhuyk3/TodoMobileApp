// ignore_for_file: constant_identifier_names

import 'package:supabase_flutter/supabase_flutter.dart';

enum ErrorInformation {
  // Authentication
  EMPTY_PASSWORD(message: 'Mật khẩu không được bỏ trống'),
  EMPTY_CONFIRMED_PASSWORD(message: 'Mật khẩu xác nhận không được bỏ trống'),
  CONFIRMED_PASSWORD_MISSMATCH(message: 'Mật khẩu xác nhận không khớp'),
  EMPTY_FULL_NAME(message: 'Họ và tên không được bỏ trống'),

  EMAIL_NOT_EXISTS(message: 'Email không tồn tại trong hệ thống'),
  EMAIL_ALREADY_EXISTS(message: 'Email đã được sử dụng'),

  // OTP / Auth
  OTP_TOO_MANY_REQUESTS(message: 'Bạn đã yêu cầu mã OTP quá nhiều lần'),
  OTP_INVALID(message: 'Mã OTP không hợp lệ hoặc đã hết hạn'),
  OTP_SEND_FAILED(message: 'Không thể gửi mã OTP'),
  AUTH_INVALID_CREDENTIALS(message: 'Thông tin đăng nhập không hợp lệ'),
  OTP_EXPIRED(message: 'Mã OTP đã hết hạn'),
  OTP_VERIFY_FAILED(message: 'Xác thực OTP thất bại'),

  // Database
  DB_NOT_NULL_VIOLATION(message: 'Thiếu dữ liệu bắt buộc'),
  DB_FOREIGN_KEY_VIOLATION(message: 'Dữ liệu liên kết không tồn tại'),
  DB_INVALID_FORMAT(message: 'Dữ liệu không đúng định dạng'),
  DB_PERMISSION_DENIED(message: 'Không có quyền thực hiện thao tác'),
  DB_RLS_VIOLATION(message: 'Dữ liệu bị chặn bởi chính sách bảo mật'),

  UNDEFINED_ERROR(message: 'Lỗi không xác định được');

  final String message;

  const ErrorInformation({required this.message});
}

ErrorInformation mapAuthException(AuthException e) {
  final message = e.message.toLowerCase();

  if (message.contains('invalid login credentials')) {
    return ErrorInformation.EMAIL_NOT_EXISTS;
  }

  if (message.contains('user already registered')) {
    return ErrorInformation.EMAIL_ALREADY_EXISTS;
  }

  if (message.contains('too many requests') || message.contains('rate limit')) {
    return ErrorInformation.OTP_TOO_MANY_REQUESTS;
  }

  if (message.contains('otp') && message.contains('invalid')) {
    return ErrorInformation.OTP_INVALID;
  }

  if (message.contains('invalid') || message.contains('token')) {
    return ErrorInformation.OTP_INVALID;
  }

  if (message.contains('expired')) {
    return ErrorInformation.OTP_EXPIRED;
  }

  return ErrorInformation.UNDEFINED_ERROR;
}

ErrorInformation mapPostgrestException(PostgrestException e) {
  switch (e.code) {
    case '23505':
      return ErrorInformation.EMAIL_ALREADY_EXISTS;

    case '23502':
      return ErrorInformation.DB_NOT_NULL_VIOLATION;

    case '23503':
      return ErrorInformation.DB_FOREIGN_KEY_VIOLATION;

    case '22P02':
      return ErrorInformation.DB_INVALID_FORMAT;

    case '42501':
      return ErrorInformation.DB_PERMISSION_DENIED;

    case 'PGRST116':
      return ErrorInformation.DB_RLS_VIOLATION;

    default:
      return ErrorInformation.UNDEFINED_ERROR;
  }
}

class Failure {
  final ErrorInformation error;
  final Object? details;

  const Failure({required this.error, this.details});

  String get message => error.message;
}
