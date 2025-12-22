import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/primary_button.dart';
import '../../bloc/bloc.dart';

class RegistrationNextStepButton extends StatelessWidget {
  const RegistrationNextStepButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        return PrimaryButton(
          title: 'Gửi mã xác thực OTP',
          onPressed: () {
            context.read<RegistrationBloc>().add(
              RegistrationPasswordSubmitted(),
            );
          },
        );
      },
    );
  }
}
