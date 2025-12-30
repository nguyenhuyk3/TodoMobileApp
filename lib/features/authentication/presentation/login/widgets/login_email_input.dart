import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../../../../core/constants/others.dart';
import '../../../../../../../core/constants/sizes.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/widgets/error_displayer.dart';
import '../bloc/bloc.dart';

class LoginEmailInput extends StatefulWidget {
  const LoginEmailInput({super.key});

  @override
  State<LoginEmailInput> createState() => _LoginEmailInputState();
}

class _LoginEmailInputState extends State<LoginEmailInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, String>(
      selector: (state) {
        return state.error;
      },
      builder: (context, error) {
        // Bắt lỗi ở password input để không hiển thị ở email input
        final displayError = context.select<LoginBloc, String>((bloc) {
          final state = bloc.state;
          final errorMsg = state.error;

          // Ô mật khẩu chính chỉ hiện lỗi 'Empty Password' hoặc 'Too short'
          if (errorMsg == ErrorInformation.EMPTY_PASSWORD.message ||
              errorMsg == ErrorInformation.PASSWORD_TOO_SHORT.message ||
              errorMsg == ErrorInformation.PASSWORD_MISSING_LOWERCASE.message ||
              errorMsg == ErrorInformation.PASSWORD_MISSING_UPPERCASE.message ||
              errorMsg == ErrorInformation.PASSWORD_MISSING_NUMBER.message ||
              errorMsg ==
                  ErrorInformation.PASSWORD_MISSING_SPECIAL_CHAR.message) {
            return '';
          }

          return errorMsg; // Không phải lỗi của mình thì không hiển thị
        });
        final hasError = displayError.isNotEmpty;
        final isLoading =
            context.watch<LoginBloc>().state.status ==
            FormzSubmissionStatus.inProgress;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
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
                key: const Key('login_emailInput_textField'),
                controller: _controller,
                focusNode: _focusNode,
                enabled: !isLoading,
                onChanged:
                    (email) => context.read<LoginBloc>().add(
                      LoginEmailChanged(email: email),
                    ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: TextSizes.TITLE_SMALL,
                  fontWeight: FontWeight.w500,
                  color:
                      isLoading
                          ? COLORS.SECONDARY_TEXT_COLOR
                          : COLORS.PRIMARY_TEXT_COLOR,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      (_focusNode.hasFocus && !isLoading)
                          ? Colors.white
                          : COLORS.INPUT_BG_COLOR,
                  hintText: 'Nhập địa chỉ email',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: TextSizes.TITLE_X_SMALL,
                  ),
                  // Label nổi
                  labelText: 'Địa chỉ Email',
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
                  // Icons
                  prefixIcon: Icon(
                    Icons.mail_rounded,
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
                                color:
                                    COLORS
                                        .FOCUSED_BORDER_IP_COLOR, // Thay màu phù hợp
                              ),
                            ),
                          )
                          : (_controller.text.isNotEmpty)
                          ? IconButton(
                            icon: Icon(
                              Icons.cancel,
                              size: IconSizes.ICON_INPUT_SIZE,
                              color:
                                  hasError
                                      ? COLORS.ERROR_COLOR
                                      : COLORS.FOCUSED_BORDER_IP_COLOR,
                            ),
                            onPressed: () {
                              _controller.clear();

                              context.read<LoginBloc>().add(
                                const LoginEmailChanged(email: ''),
                              );
                            },
                          )
                          : null,
                  // Border configs
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
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
                      color: COLORS.UNFOCUSED_BORDER_IP_COLOR.withOpacity(0.5),
                      width: 0.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: COLORS.ERROR_COLOR, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: COLORS.ERROR_COLOR, width: 1),
                  ),
                  errorText: null,
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
            ),

            if (hasError) ErrorDisplayer(message: error),
          ],
        );
      },
    );
  }
}
