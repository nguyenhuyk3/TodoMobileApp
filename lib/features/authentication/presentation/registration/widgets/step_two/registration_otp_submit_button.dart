import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/primary_button.dart';
import '../../bloc/bloc.dart';

class RegistrationOtpSubmitButton extends StatelessWidget {
  const RegistrationOtpSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen:
          (prev, curr) =>
              curr is RegistrationLoading || prev is RegistrationLoading,
      builder: (context, state) {
        return PrimaryButton(
          title: 'Xác nhận',
          isLoading: state is RegistrationLoading,
          onPressed:
              () => context.read<RegistrationBloc>().add(
                RegistrationOtpSubmitted(),
              ),
        );
      },
    );
  }
}
