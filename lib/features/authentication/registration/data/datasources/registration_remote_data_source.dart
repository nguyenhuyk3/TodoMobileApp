import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/constants/others.dart';

class RegistrationRemoteDataSource {
  final SupabaseClient _supabaseClient;

  RegistrationRemoteDataSource({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  Future<bool> checkEmailExists({required String email}) async {
    return await _supabaseClient
            .from(TABLES.USERS)
            .select('u_email')
            .eq('u_email', email)
            .maybeSingle() !=
        null;
  }
}
