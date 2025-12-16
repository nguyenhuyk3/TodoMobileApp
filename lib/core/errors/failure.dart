// ignore_for_file: constant_identifier_names

enum ErrorInformation {
  // Authentication
  EMPTY_PASSWORD(message: 'Mật khẩu không được bỏ trống'),
  EMPTY_CONFIRMED_PASSWORD(message: 'Mật khẩu xác nhận không được bỏ trống'),
  CONFIRMED_PASSWORD_MISSMATCH(message: 'Mật khẩu xác nhận không khớp'),
  EMPTY_FULL_NAME(message: 'Họ và tên không được bỏ trống'),

  EMAIL_NOT_EXISTS(message: 'Email không tồn tại trong hệ thống'),
  EMAIL_ALREADY_EXISTS(message: 'Email đã được sử dụng'),

  UNDEFINED_ERROR(message: 'Lỗi không xác định được');

  final String message;

  const ErrorInformation({required this.message});
}

class Failure {
  final ErrorInformation error;
  final Object? details;

  const Failure({required this.error, this.details});

  String get message => error.message;
}
