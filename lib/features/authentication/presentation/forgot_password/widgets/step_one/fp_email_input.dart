import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/others.dart';
import '../../../../../../../core/constants/sizes.dart';
import '../../../../../../core/widgets/error_displayer.dart';
import '../../bloc/bloc.dart';

class FPEmailInput extends StatefulWidget {
  const FPEmailInput({super.key});

  @override
  State<FPEmailInput> createState() => _FPEmailInputState();
}

class _FPEmailInputState extends State<FPEmailInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        final String error = (state is ForgotPasswordError) ? state.error : '';
        final isStepOne = state is ForgotPasswordStepOne;
        final isLoading = isStepOne && state.isLoading;
        final hasError = error.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiệu ứng bao quanh nhẹ nhàng hơn
            AnimatedContainer(
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
                key: const Key('registration_emailInput_stepOne_textField'),
                controller: _controller,
                focusNode: _focusNode,
                onChanged:
                    (email) => context.read<ForgotPasswordBloc>().add(
                      ForgotPasswordEmailChanged(email: email),
                    ),
                keyboardType: TextInputType.emailAddress,
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
                  // suffixIcon:
                  // - Chỉ hiển thị khi TextField có nội dung (_controller.text.isNotEmpty)
                  // - Nếu đang loading → ẩn icon để tránh user thao tác
                  // - Khi không loading → hiển thị nút clear (icon cancel)
                  suffixIcon:
                      (_controller.text.isNotEmpty && isStepOne && !isLoading)
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

                              context.read<ForgotPasswordBloc>().add(
                                const ForgotPasswordEmailChanged(email: ''),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: COLORS.ERROR_COLOR, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: COLORS.ERROR_COLOR, width: 1),
                  ),
                  // Xóa errorText mặc định để custom vị trí đẹp hơn
                  errorText: null,
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
            ),

            // Tùy chỉnh Error Message dưới TextField (mượt hơn)
            if (hasError) ErrorDisplayer(message: error),
          ],
        );
      },
    );
  }
}
