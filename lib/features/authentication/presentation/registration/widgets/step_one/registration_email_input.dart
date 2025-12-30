import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/widgets/error_displayer.dart';
import '../../bloc/bloc.dart';

/*
    FocusNode trong Flutter là đối tượng dùng để quản lý trạng thái focus (đang được chọn / đang nhập) 
  của một widget có thể nhận input (TextField, TextFormField, Button, v.v.).
    Hiểu ngắn gọn 👇
      FocusNode = “con trỏ biết widget nào đang được focus”

    TextEditingController là bộ điều khiển nội dung của TextField.
    Controller quản lý "View State" (vị trí con trỏ, vùng chọn), Bloc quản lý "Data State" (giá trị email).
*/
class RegistrationEmailInput extends StatefulWidget {
  const RegistrationEmailInput({super.key});

  @override
  State<RegistrationEmailInput> createState() => _RegistrationEmailInputState();
}

class _RegistrationEmailInputState extends State<RegistrationEmailInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Lắng nghe thay đổi controller để render lại nút xóa (X)
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
    // ---- LOGIC BẮT LỖI & LOADING ----
    final String errorDisplay = context.select<RegistrationBloc, String>((
      bloc,
    ) {
      final state = bloc.state;

      if (state is! RegistrationStepOne) {
        return '';
      }
      // Chỉ lấy lỗi nếu chuỗi lỗi trùng với các lỗi quy định của Email
      if (state.error == ErrorInformation.EMAIL_CAN_NOT_BE_BLANK.message ||
          state.error == ErrorInformation.INVALID_EMAIL.message) {
        return state.error;
      }

      return '';
    });
    final bool hasError = errorDisplay.isNotEmpty;
    // Cần lấy isLoading để disable nút xóa
    final bool isLoading = context.select<RegistrationBloc, bool>((bloc) {
      final state = bloc.state;

      return state is RegistrationStepOne && state.isLoading;
    });
    // ------------------------------------

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiệu ứng bao quanh nhẹ nhàng hơn
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (_focusNode.hasFocus &&
                  !isLoading) // Không show shadow khi đang loading
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
            // [QUAN TRỌNG 1] Khóa thao tác khi đang loading
            enabled: !isLoading,
            onChanged:
                (email) => {
                  context.read<RegistrationBloc>().add(
                    RegistrationEmailChanged(email: email),
                  ),
                },
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: TextSizes.TITLE_SMALL,
              fontWeight: FontWeight.w500,
              // Giữ màu chữ đậm hơn một chút kể cả khi disabled để dễ đọc (tuỳ chọn)
              color:
                  isLoading
                      ? COLORS.SECONDARY_TEXT_COLOR
                      : COLORS.PRIMARY_TEXT_COLOR,
            ),
            decoration: InputDecoration(
              filled: true,
              // Khi disable màu nền thường bị xám đi, logic này giúp giữ màu đẹp hơn
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
                    hasError ? COLORS.ERROR_COLOR : COLORS.PRIMARY_TEXT_COLOR,
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
              /*
                suffixIcon:
                - Chỉ hiển thị khi TextField có nội dung (_controller.text.isNotEmpty)
                - Nếu đang loading → ẩn icon để tránh user thao tác
                - Khi không loading → hiển thị nút clear (icon cancel)
                [QUAN TRỌNG 2] Xử lý Suffix Icon
                - Khi Loading: Hiện vòng xoay
                - Khi có text & không loading: Hiện nút xóa
              */
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
                          context.read<RegistrationBloc>().add(
                            const RegistrationEmailChanged(email: ''),
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
              // Xóa errorText mặc định để custom vị trí đẹp hơn
              errorText: null,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
        ),
        // Tùy chỉnh Error Message dưới TextField (mượt hơn)
        if (hasError) ErrorDisplayer(message: errorDisplay),
      ],
    );
  }
}
