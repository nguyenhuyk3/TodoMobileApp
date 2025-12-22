import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/sizes.dart';
import '../../../../../core/widgets/authentication_form.dart';
import '../bloc/bloc.dart';
import '../widgets/step_three/registration_confirmed_password_button.dart';
import '../widgets/step_three/registration_password_input.dart';
import 'step_four.dart';

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
                      child: RegistrationStepFourPage(),
                    ),
              ),
            );
          }
        },
        child: Column(
          children: [
            const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

            RegistrationPasswordInput(
              label: 'Mật khẩu',
              hintText: 'Hãy nhập mật khẩu',
            ),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 1.5),

            RegistrationPasswordInput(
              label: 'Mật khẩu xác nhận',
              hintText: 'Hãy nhập mật khẩu xác nhận',
              isConfirmedPassword: true,
            ),

            const Spacer(),

            RegistrationNextStepButton(),
          ],
        ),
      ),
    );
  }
}
