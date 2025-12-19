import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../bloc/bloc.dart';

class OtpPinInput extends StatelessWidget {
  const OtpPinInput({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 70,
      textStyle: TextStyle(
        fontSize: TextSizes.TITLE_LARGE,
        fontWeight: FontWeight.w600,
        color: COLORS.PRIMARY_TEXT_COLOR,
      ),
      decoration: BoxDecoration(
        color: COLORS.PRIMARY_BG_COLOR,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: COLORS.UNFOCUSED_BORDER_IP_COLOR, width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: COLORS.FOCUSED_BORDER_IP_COLOR, width: 1.5),
      ),
    );

    return Center(
      child: Pinput(
        length: 6,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        keyboardType: TextInputType.number,
        onChanged: (value) => context.read<RegistrationBloc>().add(
              RegistrationOtpChanged(otp: value),
            ),
        onCompleted: (pin) => context.read<RegistrationBloc>().add(
              RegistrationOtpSubmitted(),
            ),
      ),
    );
  }
}