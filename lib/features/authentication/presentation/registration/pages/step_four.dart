import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/sizes.dart';
import '../../../../../core/utils/toats.dart';
import '../../../../../core/widgets/authentication_form.dart';
import '../../login/pages/login.dart';
import '../bloc/bloc.dart';
import '../widgets/step_four/registration_birth_date_picker.dart';
import '../widgets/step_four/registration_completion_button.dart';
import '../widgets/step_four/registration_error_message_displayer.dart';
import '../widgets/step_four/registration_full_name_input.dart';
import '../widgets/step_four/registration_sex_selection.dart';

class RegistrationStepFourPage extends StatelessWidget {
  const RegistrationStepFourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticationForm(
      title: 'Thông tin cá nhân',
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<RegistrationBloc>(),
                      child: LoginPage(),
                    ),
              ),
            );

            ToastUtils.showSuccess(
              context: context,
              message: 'Đăng kí tài khoản thành công',
            );
          }
        },
        child: Column(
          children: [
            const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

            RegistrationFullNameInput(),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 1.5),

            RegistrationBirthDatePicker(),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 1.5),

            RegistrationSexSelection(),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 1.5),

            RegistrationErrorMessageDisplayer(),

            const Spacer(),

            RegistrationCompletionButton(),
          ],
        ),
      ),
    );
  }
}
