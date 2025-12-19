import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/others.dart';

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

  Future<void> sendEmailOtp({required String email}) async {
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
}
