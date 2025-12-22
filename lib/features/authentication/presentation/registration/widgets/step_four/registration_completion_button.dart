import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/primary_button.dart';
import '../../bloc/bloc.dart';

class RegistrationCompletionButton extends StatelessWidget {
  const RegistrationCompletionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => current is RegistrationStepFour,
      builder: (context, state) {
        return PrimaryButton(
          title: 'Hoàn tất',
          isLoading: state is RegistrationStepFour && state.isLoading,
          onPressed: () {
            context.read<RegistrationBloc>().add(RegistrationSubmitted());
          },
        );
      },
    );
  }
}
