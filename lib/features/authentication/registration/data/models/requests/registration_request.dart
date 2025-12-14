class RegistrationRequest {
  final String email;
  final String password;
  final String fullName;
  final String birthDate;
  final String sex;

  RegistrationRequest({
    required this.email,
    required this.password,
    required this.fullName,
    required this.birthDate,
    required this.sex,
  });
}
