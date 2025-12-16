import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_mobile_app/features/authentication/registration/data/datasources/registration_remote_data_source.dart';
import 'package:todo_mobile_app/features/authentication/registration/domain/repositories/repository.dart';
import 'package:todo_mobile_app/features/authentication/registration/presentation/bloc/bloc.dart';

import 'core/constants/keys.dart';
import 'features/authentication/registration/data/repositories/repository_impl.dart';
import 'features/authentication/registration/presentation/pages/step_one.dart';

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
  late final RegistrationRepository _registrationRepository;

  @override
  void initState() {
    super.initState();

    final registrationLocalDataSource = RegistrationRemoteDataSource(
      supabaseClient: Supabase.instance.client,
    );

    _registrationRepository = RepositoryImpl(
      registrationLocalDataSource: registrationLocalDataSource,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: _registrationRepository)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (_) => RegistrationBloc(
                  registrationRepository: _registrationRepository,
                ),
          ),
        ],
        child: MaterialApp(home: RegistrationStepOnePage()),
      ),
    );
  }
}
