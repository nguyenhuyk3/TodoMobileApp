import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/others.dart';
import '../../domain/entities/user_registration.dart';

class AuthenticationRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthenticationRemoteDataSource({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  Future<bool> checkEmailExists({required String email}) async {
    return await _supabaseClient
            .from(TABLES.USERS)
            .select('u_email')
            .eq('u_email', email)
            .maybeSingle() !=
        null;
  }

  Future<void> sendEmailOTP({required String email}) async {
    await _supabaseClient.auth.signInWithOtp(
      email: email,
      shouldCreateUser: false,
    );
  }

  Future<void> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    await _supabaseClient.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.email,
    );
  }

  Future<void> register({required UserRegistrationEntity user}) async {
    // 1. Chèn vào bảng 'users' trước để lấy u_id
    await _supabaseClient.rpc(
      'register_user_function',
      params: {
        'p_email': user.email,
        'p_password': user.password, // Gửi pass thô, server tự mã hóa
        'p_full_name': user.fullName,
        // Database nhận type 'date' sẽ tự parse
        // Chuyển sang định dạng chuỗi 'yyyy-MM-dd'
        'p_dob': DateFormat('yyyy-MM-dd').format(user.dob),
        'p_sex': user.sex.name, // gửi "male" hoặc "female"
        'p_avatar_url': user.avatarUrl ?? "",
      },
    );
  }

  Future<void> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    // Không được update trực tiếp, cần dùng 1 hàm RPC nhỏ hoặc query raw
    // để gọi crypt(), nhưng Supabase client dart không support query raw
    // chứa function DB dễ dàng, nên tốt nhất là tạo thêm 1 RPC.

    // Nếu bạn muốn nhanh, tạo 1 hàm SQL RPC "change_user_password(email, pass)"
    await _supabaseClient.rpc(
      'change_user_password',
      params: {'p_email': email, 'p_new_password': newPassword},
    );
  }
}
