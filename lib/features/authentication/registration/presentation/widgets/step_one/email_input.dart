import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../bloc/bloc.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final error = context.select<RegistrationBloc, String>((bloc) {
      final state = bloc.state;

      return state is RegistrationError ? state.error : '';
    });

    return TextField(
      key: const Key('registration_emailInput_stepOne_textField'),
      onChanged:
          (email) => context.read<RegistrationBloc>().add(
            RegistrationEmailChanged(email: email),
          ),
      decoration: InputDecoration(
        filled: true,
        fillColor: COLORS.INPUT_BG_COLOR,
        prefixIcon: Icon(Icons.email_outlined),
        // Border when not focused
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: COLORS.UNFOCUSED_BORDER_COLOR,
            width: 2,
          ),
        ),
        // Border when focused
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: COLORS.FOCUSED_BORDER_COLOR, width: 2),
        ),
        // Border when error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: COLORS.UNFOCUSED_ERROR_BORDER_COLOR,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: COLORS.FOCUSED_ERROR_BORDER_COLOR,
            width: 2,
          ),
        ),
        labelText: 'Email',
        labelStyle: TextStyle(
          color: error.isEmpty ? COLORS.LABEL_COLOR : COLORS.ERROR_LABEL,
          fontSize: TextSizes.TITLE_SMALL,
          fontWeight: FontWeight.w500,
        ),
        // When label is focused (floating)
        floatingLabelStyle: TextStyle(
          color:
              error.isEmpty ? COLORS.FOCUSED_LABEL_COLOR : COLORS.ERROR_LABEL,
          fontSize: TextSizes.TITLE_X_SMALL,
          fontWeight: FontWeight.bold,
        ),
        errorText: error.isEmpty ? null : error,
        errorStyle: TextStyle(
          color: COLORS.ERROR_TEXT_COLOR,
          fontSize: TextSizes.TITLE_X_SMALL,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
