import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_mobile_app/features/authentication/presentation/registration/pages/step_one.dart';

import '../../../../../core/constants/sizes.dart';
import '../../../../../core/widgets/authentication_form.dart';
import '../bloc/bloc.dart';
import '../widgets/step_three/confirmed_password_button.dart';
import '../widgets/step_three/password_input.dart';

class RegistrationStepThreePage extends StatelessWidget {
  const RegistrationStepThreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticationForm(
      title: 'Thiết lập mật khẩu',
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationStepFour) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<RegistrationBloc>(),
                      child: RegistrationStepOnePage(),
                    ),
              ),
            );
          }
        },
        child: Column(
          children: [
            const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

            PasswordInput(label: 'Mật khẩu', hintText: 'Hãy nhập mật khẩu'),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 1.5),

            PasswordInput(
              label: 'Mật khẩu xác nhận',
              hintText: 'Hãy nhập mật khẩu xác nhận',
              isConfirmedPassword: true,
            ),

            const Spacer(),

            NextStepButton(),
          ],
        ),
      ),
    );
  }
}
