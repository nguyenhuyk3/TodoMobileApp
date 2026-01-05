import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/widgets/error_displayer.dart';
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
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
      ;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bắt lỗi ở email input để không hiển thị ở email input
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
    final isLoading =
        context.watch<LoginBloc>().state.status ==
        FormzSubmissionStatus.inProgress;

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
                  enabled: !isLoading,
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
