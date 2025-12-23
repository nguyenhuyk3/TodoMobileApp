import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/widgets/error_displayer.dart';
import '../../bloc/bloc.dart';

class RegistrationErrorMessageDisplayer extends StatelessWidget {
  const RegistrationErrorMessageDisplayer({super.key});

  @override
  Widget build(BuildContext context) {
    return (BlocSelector<RegistrationBloc, RegistrationState, String>(
      selector: (state) => state is RegistrationStepFour ? state.error : '',
      builder: (context, error) {
        // KIỂM TRA: Có lỗi và lỗi đó KHÔNG PHẢI là EMPTY_FULL_NAME
        final bool hasGeneralError =
            error.isNotEmpty &&
            error != ErrorInformation.EMPTY_FULL_NAME.message;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (hasGeneralError)
              ErrorDisplayer(message: error)
            else
              const SizedBox.shrink(), // Trả về widget trống nếu không có lỗi chung
          ],
        );
      },
    ));
  }
}
