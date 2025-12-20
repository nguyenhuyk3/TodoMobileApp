import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/sizes.dart';
import '../../../../../core/widgets/authentication_form.dart';
import '../bloc/bloc.dart';
import '../widgets/step_two/otp_info_section.dart';
import '../widgets/step_two/otp_pin_put.dart';
import '../widgets/step_two/otp_submit_button.dart';
import '../widgets/step_two/otp_timer_resent.dart';

class RegistrationStepTwoPage extends StatelessWidget {
  const RegistrationStepTwoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.read<RegistrationBloc>().email;

    return AuthenticationForm(
      title: 'Nhập mã OTP',
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationStepOne) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<RegistrationBloc>(),
                      // Need to change
                      child: const RegistrationStepTwoPage(),
                    ),
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OtpInfoSection(email: email),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

            const OtpPinInput(),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

            const OtpTimerResend(),

            const Spacer(),

            const OtpSubmitButton(),
          ],
        ),
      ),
    );
  }
}
