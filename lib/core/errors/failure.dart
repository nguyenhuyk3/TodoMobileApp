// ignore_for_file: constant_identifier_names

enum ErrorInformation {
  // Authentication
  EMPTY_PASSWORD(message: 'Mật khẩu không được bỏ trống'),
  EMPTY_CONFIRMED_PASSWORD(message: 'Mật khẩu xác nhận không được bỏ trống'),
  CONFIRMED_PASSWORD_MISSMATCH(message: 'Mật khẩu xác nhận không khớp'),
  EMPTY_FULL_NAME(message: 'Họ và tên không được bỏ trống');

  final String message;
  final Object? details;

  // ignore: unused_element_parameter
  const ErrorInformation({required this.message, this.details});
}

class Failure {
  final ErrorInformation error;
  const Failure(this.error);
  String get message => error.message;
  Object? get details => error.details;
}
