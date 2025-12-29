import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/widgets/error_displayer.dart';
import '../../bloc/bloc.dart';

class RegistrationFullNameInput extends StatefulWidget {
  @override
  State<RegistrationFullNameInput> createState() => RegistrationFullNameInputState();
}

class RegistrationFullNameInputState extends State<RegistrationFullNameInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegistrationBloc, RegistrationState, String>(
      selector: (state) => state is RegistrationStepFour ? state.error : '',
      builder: (context, error) {
        // CHỈ hiển thị lỗi nếu lỗi đó là EMPTY_FULL_NAME
        final bool isNameError =
            error == ErrorInformation.EMPTY_FULL_NAME.message;
        final String displayError = isNameError ? error : '';
        final hasError = displayError.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                focusNode: _focusNode,
                onChanged: (fullName) {
                  final currentState = context.read<RegistrationBloc>().state;

                  if (currentState is RegistrationStepFour) {
                    context.read<RegistrationBloc>().add(
                      RegistrationInformationChanged(
                        fullName: fullName,
                        birthDate: currentState.birthDate,
                        sex: currentState.sex,
                      ),
                    );
                  }
                },
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
                        hasError
                            ? COLORS.ERROR_COLOR
                            : COLORS.PRIMARY_TEXT_COLOR,
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
                ),
                onTapOutside: (_) => _focusNode.unfocus(),
              ),
            ),
            if (hasError) ErrorDisplayer(message: error),
          ],
        );
      },
    );
  }
}
