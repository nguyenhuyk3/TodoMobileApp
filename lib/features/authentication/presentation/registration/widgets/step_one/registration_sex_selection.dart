import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../bloc/bloc.dart';

class RegistrationSexSelection extends StatelessWidget {
  const RegistrationSexSelection({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lấy giới tính hiện tại
    final currentSex = context.select<RegistrationBloc, String>((bloc) {
      return bloc.state is RegistrationStepOne
          ? (bloc.state as RegistrationStepOne).sex
          : 'male';
    });
    // 2. Lấy trạng thái Loading
    final bool isLoading = context.select<RegistrationBloc, bool>((bloc) {
      final state = bloc.state;

      return state is RegistrationStepOne && state.isLoading;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Giới tính",
            style: TextStyle(
              color: COLORS.LABEL_COLOR,
              fontWeight: FontWeight.bold,
              fontSize: TextSizes.TITLE_XX_SMALL,
            ),
          ),
        ),
        Row(
          children: [
            _buildSexOption(
              context: context,
              title: 'Nam',
              value: 'male',
              isSelected: currentSex == 'male',
              isLoading: isLoading,
            ),

            const SizedBox(width: X_MIN_WIDTH_SIZED_BOX * 4),

            _buildSexOption(
              context: context,
              title: 'Nữ',
              value: 'female',
              isSelected: currentSex == 'female',
              isLoading: isLoading,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSexOption({
    required BuildContext context,
    required String title,
    required String value,
    required bool isSelected,
    required bool isLoading,
  }) {
    return Expanded(
      child: GestureDetector(
        // [QUAN TRỌNG] Disable thao tác khi isLoading
        onTap:
            isLoading
                ? null
                : () {
                  final state = context.read<RegistrationBloc>().state;

                  if (state is RegistrationStepOne) {
                    context.read<RegistrationBloc>().add(
                      RegistrationInformationChanged(
                        fullName: state.fullName,
                        birthDate: state.birthDate,
                        sex: value,
                      ),
                    );
                  }
                },
        /*
          AnimatedContainer dùng để tạo hiệu ứng chuyển trạng thái mượt
          khi item được chọn / bỏ chọn.

          - duration: 300ms
          👉 Thời gian animation khi các thuộc tính thay đổi.
          - padding: vertical 14
          👉 Giữ chiều cao item ổn định, dễ bấm.
          - background color:
          👉 isSelected = true:
            + Dùng màu focus với opacity 0.1 để tạo hiệu ứng highlight nhẹ
          👉 isSelected = false:
            + Màu nền input mặc định
          - border:
          👉 isSelected = true:
            + Viền đậm hơn (1.5)
            + Màu focus → thể hiện trạng thái đang chọn
          👉 isSelected = false:
            + Viền mỏng (0.7)
            + Màu unfocused
          - borderRadius: 12
          👉 Bo góc mềm, đồng bộ với design input/card
        */
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color:
                isSelected
                    // ignore: deprecated_member_use
                    ? COLORS.FOCUSED_BORDER_IP_COLOR.withOpacity(0.1)
                    : (isLoading
                        ? Colors.grey.shade100
                        : COLORS.INPUT_BG_COLOR),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (isSelected
                      ? COLORS.FOCUSED_BORDER_IP_COLOR
                      : COLORS.UNFOCUSED_BORDER_IP_COLOR)
                  // ignore: deprecated_member_use
                  .withOpacity(isLoading ? 0.5 : 1.0), // Mờ border khi loading
              width: isSelected ? 1.5 : 0.7,
            ),
          ),
          child: Center(
            child:
                isLoading && isSelected
                    // Hiển thị vòng xoay nhỏ bên trong ô đang chọn khi Loading (tùy chọn)
                    ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: COLORS.FOCUSED_BORDER_IP_COLOR,
                      ),
                    )
                    : Text(
                      title,
                      style: TextStyle(
                        color:
                            isLoading
                                ? Colors
                                    .grey
                                    .shade400 // Mờ text khi loading
                                : (isSelected
                                    ? COLORS.PRIMARY_TEXT_COLOR
                                    : COLORS.SECONDARY_TEXT_COLOR),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
