// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/sizes.dart';
import '../../../../../core/widgets/authentication_form.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../bloc/bloc.dart';
import '../widgets/step_one/email_input.dart';

class RegistrationStepOnePage extends StatelessWidget {
  const RegistrationStepOnePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationBloc>().add(RegistrationReset());
    });

    return AuthenticationForm(
      title: 'Đăng kí',
      allowBack: true,
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationStepTwo) {
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

            EmailInput(),

            const Spacer(),

            PrimaryButton(
              onPressed:
                  () => {
                    context.read<RegistrationBloc>().add(
                      RegistrationEmailSubmitted(),
                    ),
                  },
              title: 'Gửi mã xác thực OTP',
            ),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX),
            const SizedBox(height: MAX_HEIGTH_SIZED_BOX),
          ],
        ),
      ),
    );
  }
}
