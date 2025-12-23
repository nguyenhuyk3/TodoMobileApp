import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_mobile_app/features/authentication/presentation/forgot_password/bloc/bloc.dart';

import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/widgets/error_displayer.dart';

class FPErrorMessageDisplayer extends StatelessWidget {
  const FPErrorMessageDisplayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ForgotPasswordBloc, ForgotPasswordState, String>(
      selector: (state) => state is ForgotPasswordStepThree ? state.error : '',
      builder: (context, error) {
        final isIgnoredError =
            error == ErrorInformation.EMPTY_CONFIRMED_PASSWORD.message ||
            error == ErrorInformation.CONFIRMED_PASSWORD_MISSMATCH.message ||
            error == ErrorInformation.EMPTY_PASSWORD.message ||
            error.contains('kí tự') ||
            error.isEmpty;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isIgnoredError)
              const SizedBox.shrink() //Trả về widget trống nếu không có lỗi chung
            else
              ErrorDisplayer(message: error),
          ],
        );
      },
    );
  }
}
