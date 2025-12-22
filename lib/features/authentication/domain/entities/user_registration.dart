import 'enums.dart';

class UserRegistrationEntity {
  final String email;
  final String password;
  final String fullName;
  final DateTime dob;
  final Sex sex;
  final String? avatarUrl;

  UserRegistrationEntity({
    required this.email,
    required this.password,
    required this.fullName,
    required this.dob,
    required this.sex,
    this.avatarUrl,
  });
}
