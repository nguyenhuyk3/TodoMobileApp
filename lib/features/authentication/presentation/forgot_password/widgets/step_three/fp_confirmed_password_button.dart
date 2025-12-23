import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/primary_button.dart';
import '../../bloc/bloc.dart';

class FPConfirmedPasswordButton extends StatelessWidget {
  const FPConfirmedPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen:
          (prev, curr) =>
              curr is ForgotPasswordLoading || prev is ForgotPasswordLoading,
      builder: (context, state) {
        return PrimaryButton(
          title: 'Xác nhận',
          isLoading: state is ForgotPasswordLoading,
          onPressed: () {
            context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted());
          },
        );
      },
    );
  }
}
