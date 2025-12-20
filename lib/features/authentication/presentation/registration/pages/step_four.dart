import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/sizes.dart';
import '../../../../../core/widgets/authentication_form.dart';
import '../bloc/bloc.dart';
import '../widgets/step_four/birth_date_picker.dart';
import '../widgets/step_four/completion_button.dart';
import '../widgets/step_four/full_name_input.dart';
import '../widgets/step_four/sex_selection.dart';
import 'step_one.dart';

class RegistrationStepFourPage extends StatelessWidget {
  const RegistrationStepFourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticationForm(
      title: 'Thông tin cá nhân',
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
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

            FullNameInput(),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 1.5),

            BirthDatePicker(),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 1.5),

            SexSelection(),

            const Spacer(),

            CompletionButton(),
          ],
        ),
      ),
    );
  }
}
