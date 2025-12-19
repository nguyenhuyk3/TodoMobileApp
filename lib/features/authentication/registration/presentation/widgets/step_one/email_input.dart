import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../bloc/bloc.dart';

/*
    FocusNode trong Flutter là đối tượng dùng để quản lý trạng thái focus (đang được chọn / đang nhập) 
  của một widget có thể nhận input (TextField, TextFormField, Button, v.v.).
    Hiểu ngắn gọn 👇
      FocusNode = “con trỏ biết widget nào đang được focus”
*/
class EmailInput extends StatefulWidget {
  const EmailInput({super.key});

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
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
    return BlocSelector<RegistrationBloc, RegistrationState, String>(
      selector: (state) {
        return (state is RegistrationError) ? state.error : '';
      },
      builder: (context, error) {
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
                    (email) => context.read<RegistrationBloc>().add(
                      RegistrationEmailChanged(email: email),
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
                  suffixIcon:
                      _controller.text.isNotEmpty
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

                    Text(
                      error,
                      style: TextStyle(
                        color: COLORS.ERROR_COLOR,
                        fontSize: TextSizes.TITLE_XX_SMALL,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

// class EmailInput extends StatelessWidget {
//   const EmailInput({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<RegistrationBloc, RegistrationState, String>(
//       selector: (state) {
//         if (state is RegistrationError) {
//           return state.error;
//         }

//         return '';
//       },
//       builder: (context, error) {
//         final borderRadius = BorderRadius.circular(8);
//         final focusNode = FocusNode();

//         return TextField(
//           key: const Key('registration_emailInput_stepOne_textField'),
//           focusNode: focusNode,
//           onChanged:
//               (email) => context.read<RegistrationBloc>().add(
//                 RegistrationEmailChanged(email: email),
//               ),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: COLORS.INPUT_BG_COLOR,
//             hintText: 'Nhập email của bạn',
//             prefixIcon: const Icon(Icons.email_outlined),
//             border: OutlineInputBorder(borderRadius: borderRadius),
//             // Border when not focused
//             enabledBorder: OutlineInputBorder(
//               borderRadius: borderRadius,
//               borderSide: BorderSide(
//                 color: COLORS.UNFOCUSED_BORDER_IP_COLOR,
//                 width: 1.5,
//               ),
//             ),
//             // Border when focused
//             focusedBorder: OutlineInputBorder(
//               borderRadius: borderRadius,
//               borderSide: BorderSide(width: 1.5),
//             ),
//             // Border when error
//             errorBorder: OutlineInputBorder(
//               borderRadius: borderRadius,
//               borderSide: BorderSide(color: COLORS.ERROR_COLOR, width: 1.5),
//             ),

//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: borderRadius,
//               borderSide: BorderSide(color: COLORS.ERROR_COLOR, width: 1.5),
//             ),

//             labelText: 'Email',
//             labelStyle: TextStyle(
//               color: error.isEmpty ? COLORS.LABEL_COLOR : COLORS.ERROR_COLOR,
//               fontSize: TextSizes.TITLE_SMALL,
//               fontWeight: FontWeight.w400,
//             ),

//             // When label is focused (floating)
//             floatingLabelStyle: TextStyle(
//               color:
//                   error.isEmpty
//                       ? COLORS.FOCUSED_LABEL_COLOR
//                       : COLORS.ERROR_COLOR,
//               fontSize: TextSizes.TITLE_X_SMALL,
//               fontWeight: FontWeight.bold,
//             ),

//             errorText: error.isEmpty ? null : error,
//             errorStyle: TextStyle(
//               color: COLORS.ERROR_COLOR,
//               fontSize: TextSizes.TITLE_X_SMALL,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class EmailInput extends StatelessWidget {
//   const EmailInput({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final error = context.select<RegistrationBloc, String>((bloc) {
//       final state = bloc.state;

//       return state is RegistrationError ? state.error : '';
//     });

//     return TextField(
//       key: const Key('registration_emailInput_stepOne_textField'),
//       onChanged:
//           (email) => context.read<RegistrationBloc>().add(
//             RegistrationEmailChanged(email: email),
//           ),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: COLORS.INPUT_BG_COLOR,
//         prefixIcon: Icon(Icons.email_outlined),
//         // Border when not focused
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: COLORS.UNFOCUSED_BORDER_COLOR,
//             width: 2,
//           ),
//         ),
//         // Border when focused
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: COLORS.FOCUSED_BORDER_COLOR, width: 2),
//         ),
//         // Border when error
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(
//             color: COLORS.UNFOCUSED_ERROR_BORDER_COLOR,
//             width: 2,
//           ),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(
//             color: COLORS.FOCUSED_ERROR_BORDER_COLOR,
//             width: 2,
//           ),
//         ),
//         labelText: 'Email',
//         labelStyle: TextStyle(
//           color: error.isEmpty ? COLORS.LABEL_COLOR : COLORS.ERROR_LABEL,
//           fontSize: TextSizes.TITLE_SMALL,
//           fontWeight: FontWeight.w500,
//         ),
//         // When label is focused (floating)
//         floatingLabelStyle: TextStyle(
//           color:
//               error.isEmpty ? COLORS.FOCUSED_LABEL_COLOR : COLORS.ERROR_LABEL,
//           fontSize: TextSizes.TITLE_X_SMALL,
//           fontWeight: FontWeight.bold,
//         ),
//         errorText: error.isEmpty ? null : error,
//         errorStyle: TextStyle(
//           color: COLORS.ERROR_TEXT_COLOR,
//           fontSize: TextSizes.TITLE_X_SMALL,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }
// }
