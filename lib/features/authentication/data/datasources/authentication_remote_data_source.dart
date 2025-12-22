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
      shouldCreateUser: true,
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
    final response =
        await _supabaseClient
            .from('users')
            .insert({
              'u_email': user.email,
              'u_password': user.password,
              'u_source': 'app',
            })
            .select('u_id')
            .single();
    final String userId = response['u_id'];

    // 2. Chèn vào bảng 'personal_information' sử dụng u_id vừa lấy được
    await _supabaseClient.from(TABLES.PERSONAL_INFORMATION).insert({
      'u_id': userId,
      'pi_full_name': user.fullName,
      'pi_date_of_birth': user.dob.toIso8601String(),
      'pi_sex': user.sex.name,
      'pi_avatar_url': user.avatarUrl ?? "",
    });
  }
}
