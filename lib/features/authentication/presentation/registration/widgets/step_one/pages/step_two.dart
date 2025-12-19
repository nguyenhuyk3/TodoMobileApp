import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:todo_mobile_app/core/constants/sizes.dart';

import '../../../../../../../core/constants/others.dart';
import '../../../../../../../core/widgets/authentication_form.dart';
import '../../../../../../../core/widgets/primary_button.dart';
import '../../../bloc/bloc.dart';

class RegistrationStepTwoPage extends StatefulWidget {
  const RegistrationStepTwoPage({super.key});

  @override
  State<RegistrationStepTwoPage> createState() =>
      _RegistrationStepTwoPageState();
}

class _RegistrationStepTwoPageState extends State<RegistrationStepTwoPage> {
  int _counter = 20; // Giống trong ảnh (00:20)
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() => _counter--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cấu hình style cho các ô nhập OTP (giống trong ảnh)
    final defaultPinTheme = PinTheme(
      width: 65,
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

    final email = context.read<RegistrationBloc>().email;

    return AuthenticationForm(
      title: 'Nhập mã OTP',
      allowBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chúng tôi đã gửi mã OTP đến địa chỉ ${email} của bạn',
            style: TextStyle(
              fontSize: TextSizes.TITLE_X_SMALL,
              color: COLORS.PRIMARY_TEXT_COLOR,
              height: 1.5,
            ),
          ),

          const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

          // PHẦN NHẬP MÃ PIN (SỬ DỤNG PINPUT)
          Center(
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // context.read<RegistrationBloc>().add(
                //   RegistrationOtpChanged(otp: value),
                // );
              },
              onCompleted: (pin) {
                // context.read<RegistrationBloc>().add(
                //   RegistrationOtpSubmitted(),
                // );
              },
            ),
          ),

          const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 2),

          // THÔNG BÁO GỬI LẠI MÃ
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Gửi lại mã ',
                  style: TextStyle(
                    color:
                        _counter == 0
                            ? Colors.black
                            : COLORS.PRIMARY_TEXT_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _counter > 0
                      ? '00:${_counter.toString().padLeft(2, '0')}'
                      : '',
                  style: TextStyle(
                    color: COLORS.PRIMARY_TEXT_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) {
              return PrimaryButton(
                title: 'Xác nhận',
                isLoading: state is RegistrationLoading,
                onPressed: () {
                  context.read<RegistrationBloc>().add(
                    RegistrationOtpSubmitted(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
