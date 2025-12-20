import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/primary_button.dart';
import '../../bloc/bloc.dart';

class CompletionButton extends StatelessWidget {
  const CompletionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        return PrimaryButton(
          title: 'Hoàn tất',
          isLoading: state is RegistrationLoading,
          onPressed: () {
            context.read<RegistrationBloc>().add(RegistrationSubmitted());
          },
        );
      },
    );
  }
}
