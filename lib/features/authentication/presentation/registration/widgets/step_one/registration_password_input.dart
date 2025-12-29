import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/widgets/error_displayer.dart';
import '../../../password/bloc/bloc.dart';
import '../../bloc/bloc.dart';

class RegistrationPasswordInput extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isConfirmedPassword;

  const RegistrationPasswordInput({
    super.key,
    required this.label,
    required this.hintText,
    this.isConfirmedPassword = false,
  });

  @override
  State<RegistrationPasswordInput> createState() =>
      _RegistrationPasswordInputState();
}

class _RegistrationPasswordInputState extends State<RegistrationPasswordInput> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Lắng nghe focus để setState (dành cho các hiệu ứng UI nếu cần)
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. LOGIC LỌC LỖI
    final displayError = context.select<RegistrationBloc, String>((bloc) {
      final state = bloc.state;
      if (state is! RegistrationStepOne) {
        return '';
      }
      final errorMsg = state.error;

      if (widget.isConfirmedPassword) {
        if (errorMsg == ErrorInformation.EMPTY_CONFIRMED_PASSWORD.message ||
            errorMsg == ErrorInformation.CONFIRMED_PASSWORD_MISSMATCH.message) {
          return errorMsg;
        }
      } else {
        if (errorMsg == ErrorInformation.EMPTY_PASSWORD.message ||
            errorMsg == ErrorInformation.PASSWORD_TOO_SHORT.message ||
            errorMsg == ErrorInformation.PASSWORD_MISSING_LOWERCASE.message ||
            errorMsg == ErrorInformation.PASSWORD_MISSING_UPPERCASE.message ||
            errorMsg == ErrorInformation.PASSWORD_MISSING_NUMBER.message ||
            errorMsg ==
                ErrorInformation.PASSWORD_MISSING_SPECIAL_CHAR.message) {
          return errorMsg;
        }
      }
      return '';
    });

    final hasError = displayError.isNotEmpty;

    // 2. LOGIC LOADING
    final bool isLoading = context.select<RegistrationBloc, bool>((bloc) {
      final state = bloc.state;
      return state is RegistrationStepOne && state.isLoading;
    });

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
                    // Chỉ hiển thị bóng khi có focus VÀ không loading
                    if (_focusNode.hasFocus && !isLoading)
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
                  // Khóa tương tác khi loading
                  enabled: !isLoading,
                  obscureText: passwordState.obscureText,
                  onChanged: (value) {
                    final currentState = context.read<RegistrationBloc>().state;
                    if (currentState is RegistrationStepOne) {
                      context.read<RegistrationBloc>().add(
                        RegistrationPasswordChanged(
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
                  style: TextStyle(
                    fontSize: TextSizes.TITLE_SMALL,
                    fontWeight: FontWeight.w500,
                    // Làm mờ text đi một chút khi loading/disabled
                    color: isLoading ? Colors.grey.shade600 : null,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    // Giữ nền trắng nếu đang focus (trừ khi loading)
                    fillColor:
                        (_focusNode.hasFocus && !isLoading)
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
                    // Suffix Icon logic: Loading -> Spinner, Normal -> Eye Toggle
                    suffixIcon:
                        isLoading
                            ? Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: COLORS.FOCUSED_BORDER_IP_COLOR,
                                ),
                              ),
                            )
                            : IconButton(
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
                    // Thêm disabledBorder để giữ giao diện đẹp khi khóa
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        // ignore: deprecated_member_use
                        color: COLORS.UNFOCUSED_BORDER_IP_COLOR.withOpacity(
                          0.5,
                        ),
                        width: 0.5,
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
          if (hasError) ErrorDisplayer(message: displayError),
        ],
      ),
    );
  }
}
