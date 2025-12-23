import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/widgets/error_displayer.dart';
import '../../../password/bloc/bloc.dart';
import '../../bloc/bloc.dart';

class FPPasswordInput extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isConfirmedPassword;

  const FPPasswordInput({
    super.key,
    required this.label,
    required this.hintText,
    this.isConfirmedPassword = false,
  });

  @override
  State<FPPasswordInput> createState() => _FPPasswordInputState();
}

class _FPPasswordInputState extends State<FPPasswordInput> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    // _focusNode.addListener(
    //   () => setState(() {}),
    // ); // Rebuild để hiệu ứng Shadow mượt mà
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TÁCH LOGIC LỌC LỖI TẠI ĐÂY
    final displayError = context.select<ForgotPasswordBloc, String>((bloc) {
      final state = bloc.state;

      if (state is! ForgotPasswordStepThree) {
        return '';
      }

      final errorMsg = state.error;

      if (widget.isConfirmedPassword) {
        // Ô xác nhận chỉ hiện lỗi nếu lỗi liên quan đến 'Empty Confirm' hoặc 'Mismatch'
        if (errorMsg == ErrorInformation.EMPTY_CONFIRMED_PASSWORD.message ||
            errorMsg == ErrorInformation.CONFIRMED_PASSWORD_MISSMATCH.message) {
          return errorMsg;
        }
      } else {
        // Ô mật khẩu chính chỉ hiện lỗi 'Empty Password' hoặc 'Too short'
        if (errorMsg == ErrorInformation.EMPTY_PASSWORD.message ||
            errorMsg.contains('kí tự')) {
          // Nhận diện lỗi 'ngắn hơn x kí tự'
          return errorMsg;
        }
      }

      return ''; // Không phải lỗi của mình thì không hiển thị
    });

    final hasError = displayError.isNotEmpty;

    return BlocProvider(
      create: (context) => PasswordBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<PasswordBloc, PasswordState>(
            builder: (context, passwordState) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (_focusNode.hasFocus)
                      BoxShadow(
                        color: (hasError ? COLORS.ERROR_COLOR : Colors.black)
                        // ignore: deprecated_member_use
                        .withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: TextField(
                  focusNode: _focusNode,
                  obscureText: passwordState.obscureText,
                  onChanged: (value) {
                    final currentState =
                        context.read<ForgotPasswordBloc>().state;

                    if (currentState is ForgotPasswordStepThree) {
                      context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordPasswordChanged(
                          password:
                              widget.isConfirmedPassword
                                  ? currentState.password.value
                                  : value,
                          confirmedPassword:
                              widget.isConfirmedPassword
                                  ? value
                                  : currentState.confirmedPassword,
                        ),
                      );
                    }
                  },
                  textInputAction:
                      widget.isConfirmedPassword
                          ? TextInputAction.done
                          : TextInputAction.next,
                  style: const TextStyle(
                    fontSize: TextSizes.TITLE_SMALL,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        _focusNode.hasFocus
                            ? Colors.white
                            : COLORS.INPUT_BG_COLOR,
                    hintText: widget.hintText,
                    labelText: widget.label,
                    hintStyle: TextStyle(
                      color: COLORS.HINT_TEXT_COLOR,
                      fontSize: TextSizes.TITLE_X_SMALL,
                    ),
                    labelStyle: TextStyle(
                      color: hasError ? COLORS.ERROR_COLOR : COLORS.LABEL_COLOR,
                      fontSize: TextSizes.TITLE_SMALL,
                    ),
                    floatingLabelStyle: TextStyle(
                      color:
                          hasError
                              ? COLORS.ERROR_COLOR
                              : COLORS.PRIMARY_TEXT_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: TextSizes.TITLE_XX_SMALL,
                    ),
                    prefixIcon: Icon(
                      widget.isConfirmedPassword
                          ? Icons.lock_reset_rounded
                          : Icons.lock_outline_rounded,
                      color:
                          hasError
                              ? COLORS.ERROR_COLOR
                              : (_focusNode.hasFocus
                                  ? COLORS.FOCUSED_BORDER_IP_COLOR
                                  : COLORS.UNFOCUSED_BORDER_IP_COLOR),
                      size: IconSizes.ICON_INPUT_SIZE,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordState.obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: IconSizes.ICON_INPUT_SIZE,
                        color:
                            hasError
                                ? COLORS.ERROR_COLOR
                                : COLORS.UNFOCUSED_BORDER_IP_COLOR,
                      ),
                      onPressed: () {
                        context.read<PasswordBloc>().add(
                          PasswordToggleVisibility(),
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            hasError
                                ? COLORS.ERROR_COLOR
                                : COLORS.UNFOCUSED_BORDER_IP_COLOR,
                        width: 0.7,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            hasError
                                ? COLORS.ERROR_COLOR
                                : COLORS.FOCUSED_BORDER_IP_COLOR,
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                ),
              );
            },
          ),

          // HIỂN THỊ LỖI CỤ THỂ CHO TỪNG Ô
          if (hasError) ErrorDisplayer(message: displayError),
        ],
      ),
    );
  }
}
