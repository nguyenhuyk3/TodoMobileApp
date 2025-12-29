import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/widgets/error_displayer.dart';
import '../../bloc/bloc.dart';

class RegistrationFullNameInput extends StatefulWidget {
  const RegistrationFullNameInput({super.key});

  @override
  State<RegistrationFullNameInput> createState() =>
      RegistrationFullNameInputState();
}

class RegistrationFullNameInputState extends State<RegistrationFullNameInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Rebuild để xử lý UI khi focus thay đổi
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
    final String errorDisplay = context.select<RegistrationBloc, String>((
      bloc,
    ) {
      final state = bloc.state;
      // Chỉ lấy lỗi nếu ở Step 1 và lỗi là EMPTY_FULL_NAME
      if (state is RegistrationStepOne &&
          state.error == ErrorInformation.EMPTY_FULL_NAME.message) {
        return state.error;
      }

      return '';
    });
    final bool hasError = errorDisplay.isNotEmpty;
    // 2. LOGIC LOADING
    final bool isLoading = context.select<RegistrationBloc, bool>((bloc) {
      final state = bloc.state;

      return state is RegistrationStepOne && state.isLoading;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              // Chỉ hiện shadow khi focus VÀ không loading
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
            // [QUAN TRỌNG] Disable khi đang loading
            enabled: !isLoading,
            onChanged: (fullName) {
              final currentState = context.read<RegistrationBloc>().state;

              if (currentState is RegistrationStepOne) {
                context.read<RegistrationBloc>().add(
                  RegistrationInformationChanged(
                    fullName: fullName,
                    birthDate: currentState.birthDate,
                    sex: currentState.sex,
                  ),
                );
              }
            },
            style: TextStyle(
              fontSize: TextSizes.TITLE_SMALL,
              fontWeight: FontWeight.w500,
              // Mờ text một chút khi loading
              color: isLoading ? Colors.grey.shade600 : null,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  (_focusNode.hasFocus && !isLoading)
                      ? Colors.white
                      : COLORS.INPUT_BG_COLOR,
              hintText: 'Nhập họ và tên',
              hintStyle: TextStyle(
                color: COLORS.HINT_TEXT_COLOR,
                fontSize: TextSizes.TITLE_X_SMALL,
              ),
              labelText: 'Họ và tên',
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
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color:
                    hasError
                        ? COLORS.ERROR_COLOR
                        : (_focusNode.hasFocus
                            ? COLORS.FOCUSED_BORDER_IP_COLOR
                            : COLORS.UNFOCUSED_BORDER_IP_COLOR),
                size: IconSizes.ICON_INPUT_SIZE,
              ),
              // Thêm Loading Spinner vào đuôi input khi loading
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
                      : null,
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
              // Viền khi bị disabled (loading)
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  // ignore: deprecated_member_use
                  color: COLORS.UNFOCUSED_BORDER_IP_COLOR.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ),
        // Hiển thị lỗi
        if (hasError) ErrorDisplayer(message: errorDisplay),
      ],
    );
  }
}
