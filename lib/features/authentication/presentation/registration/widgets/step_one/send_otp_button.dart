import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/primary_button.dart';
import '../../bloc/bloc.dart';

class SendOTPButton extends StatelessWidget {
  const SendOTPButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocSelector<RegistrationBloc, RegistrationState, bool>(
          selector: (state) => state is RegistrationLoading,
          builder: (context, isLoading) {
            return PrimaryButton(
              title: 'Gửi mã xác thực OTP',
              isLoading: isLoading,
              onPressed:
                  isLoading
                      ? null
                      : () {
                        context.read<RegistrationBloc>().add(
                          RegistrationEmailSubmitted(),
                        );
                      },
            );
          },
        );
      },
    );
  }
}
