import '../../domain/entities/user_registration.dart';

class RegistrationModel {
  // Chuyển từ Entity sang Map cho bảng 'users'
  static Map<String, dynamic> toUserTableMap(UserRegistrationEntity entity) {
    return {
      'u_email': entity.email,
      'u_password': entity.password, // Lưu ý: Nên băm mật khẩu hoặc dùng Supabase Auth
      'u_source': 'app', 
    };
  }

  // Chuyển từ Entity sang Map cho bảng 'personal_information'
  static Map<String, dynamic> toPersonalInfoTableMap(UserRegistrationEntity entity, String userId) {
    return {
      'u_id': userId,
      'pi_full_name': entity.fullName,
      'pi_date_of_birth': entity.dob.toIso8601String(),
      'pi_sex': entity.sex.name,
      'pi_avatar_url': entity.avatarUrl ?? "",
    };
  }
}