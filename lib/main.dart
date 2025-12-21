import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_mobile_app/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:todo_mobile_app/features/authentication/domain/repositories/repository.dart';
import 'package:todo_mobile_app/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:todo_mobile_app/features/authentication/presentation/forgot_password/bloc/bloc.dart';
import 'package:todo_mobile_app/features/authentication/presentation/forgot_password/pages/step_one.dart';
import 'package:todo_mobile_app/features/authentication/presentation/login/pages/login.dart';
import 'package:todo_mobile_app/features/authentication/presentation/registration/bloc/bloc.dart';
import 'package:todo_mobile_app/features/authentication/presentation/registration/pages/step_one.dart';

import 'core/constants/keys.dart';
import 'features/authentication/data/repositories/repository_impl.dart';
import 'features/authentication/presentation/login/bloc/bloc.dart';

Future<void> main() async {
  // Nó đảm bảo Flutter đã sẵn sàng trước khi chạy code bất đồng bộ hoặc dùng plugin.
  WidgetsFlutterBinding.ensureInitialized();
  // Tải file .env
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env[SUPABASE_URL]!,
    anonKey: dotenv.env[SUPABASE_ANON_KEY]!,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  void initState() {
    super.initState();

    final authenticationRemoteDataSource = AuthenticationRemoteDataSource(
      supabaseClient: Supabase.instance.client,
    );

    _authenticationRepository = AuthenticationRepositoryImpl(
      authenticationRemoteDataSource: authenticationRemoteDataSource,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: _authenticationRepository)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (_) => RegistrationBloc(
                  checkEmailExistsUseCase: CheckEmailExistsUseCase(
                    authenticationRepository: _authenticationRepository,
                  ),
                  sendOTPUseCase: SendOTPUseCase(
                    authenticationRepository: _authenticationRepository,
                  ),
                  verifyOTPUseCase: VerifyOTPUseCase(
                    authenticationRepository: _authenticationRepository,
                  ),
                ),
          ),
          BlocProvider(create: (_) => ForgotPasswordBloc()),
          BlocProvider(create: (_) => LoginBloc()),
        ],
        child: MaterialApp(home: LoginPage()),
      ),
    );
  }
}
