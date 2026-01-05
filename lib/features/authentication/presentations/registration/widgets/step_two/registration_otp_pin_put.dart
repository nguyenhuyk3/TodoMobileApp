import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../../../../../core/widgets/error_displayer.dart';
import '../../bloc/bloc.dart';

class RegistrationOtpPinInput extends StatelessWidget {
  const RegistrationOtpPinInput({super.key});

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
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: COLORS.ERROR_COLOR, width: 1.5),
      ),
    );

    return BlocSelector<RegistrationBloc, RegistrationState, String>(
      selector: (state) {
        return (state is RegistrationStepTwo) ? state.error : '';
      },
      builder: (context, error) {
        final hasError = error.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PHẦN NHẬP MÃ OTP
            Center(
              child: Pinput(
                length: LENGTH_OF_OTP,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme, // Theme khi báo lỗi
                forceErrorState:
                    hasError, // Kích hoạt trạng thái lỗi cho ô nhập
                keyboardType: TextInputType.number,
                onChanged:
                    (value) => context.read<RegistrationBloc>().add(
                      RegistrationOtpChanged(otp: value),
                    ),
                onCompleted:
                    (pin) => {
                      context.read<RegistrationBloc>().add(
                        RegistrationOtpSubmitted(),
                      ),
                    },
              ),
            ),

            // HIỂN THỊ THÔNG BÁO LỖI PHÍA DƯỚI
            if (hasError) ErrorDisplayer(message: error),
          ],
        );
      },
    );
  }
}
