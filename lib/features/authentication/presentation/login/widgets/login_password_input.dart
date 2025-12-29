import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../../../../core/errors/failure.dart';
import '../../password/bloc/bloc.dart';
import '../bloc/bloc.dart';

class LoginPasswordInput extends StatefulWidget {
  final String label;
  final String hintText;

  const LoginPasswordInput({
    super.key,
    required this.label,
    required this.hintText,
  });

  @override
  State<LoginPasswordInput> createState() => _LoginPasswordInputState();
}

class _LoginPasswordInputState extends State<LoginPasswordInput> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bắt lỗi ở password input để không hiển thị ở email input
    final displayError = context.select<LoginBloc, String>((bloc) {
      final state = bloc.state;
      final errorMsg = state.error;

      if (errorMsg == ErrorInformation.EMAIL_CAN_NOT_BE_BLANK.message ||
          errorMsg == ErrorInformation.INVALID_EMAIL.message) {
        return '';
      }

      return errorMsg;
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
                  onChanged: (password) {
                    context.read<LoginBloc>().add(
                      LoginPasswordChanged(password: password),
                    );
                  },
                  textInputAction: TextInputAction.next,
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
                      Icons.lock_outline_rounded,
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

          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: IconSizes.ICON_MINI_SIZE,
                    color: COLORS.ERROR_COLOR,
                  ),

                  const SizedBox(width: X_MIN_WIDTH_SIZED_BOX),

                  Expanded(
                    child: Text(
                      displayError,
                      style: TextStyle(
                        color: COLORS.ERROR_COLOR,
                        fontSize: TextSizes.TITLE_XX_SMALL,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
