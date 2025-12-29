import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/registration_params.dart';
import '../models/user.dart';

class AuthenticationRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthenticationRemoteDataSource({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  Future<bool> checkEmailExists({required String email}) async {
    return await _supabaseClient
            .from('x')
            .select('u_email')
            .eq('u_email', email)
            .maybeSingle() !=
        null;
  }

  Future<void> resendOTP({required String email, required OtpType type}) async {
    await _supabaseClient.auth.resend(email: email, type: type);
  }

  Future<void> verifyEmailOtp({
    required String email,
    required String otp,
    required OtpType type,
  }) async {
    await _supabaseClient.auth.verifyOTP(email: email, token: otp, type: type);
  }

  Future<void> register({required RegistrationParams params}) async {
    await _supabaseClient.auth.signUp(
      email: params.email,
      password: params.password,
      data: {
        'full_name': params.fullName,
        'avatar_url': params.avatarUrl,
        // Trigger SQL cast (..)::date, nên cần format chuỗi chuẩn yyyy-MM-dd
        'dob': DateFormat('yyyy-MM-dd').format(params.dateOfBirth),
        // Trigger SQL cast (..)::sex
        'sex': params.sex.name,
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

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // 1. Đăng nhập để lấy Session & Token
    final authResponse = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (authResponse.user == null) {
      throw const AuthException('Đăng nhập thất bại.');
    }

    // 2. Query thông tin từ bảng profiles (Vì AuthUser chỉ có id & email)
    final profileData =
        await _supabaseClient
            .from('profiles')
            .select()
            .eq('id', authResponse.user!.id)
            .single();

    // 3. Merge data thành Model hoàn chỉnh
    return UserModel.fromSupabase(
      profileData,
      authResponse.user!.email!,
      authResponse.user!.id,
    );
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
}
