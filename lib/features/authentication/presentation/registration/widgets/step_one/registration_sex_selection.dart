import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../bloc/bloc.dart';

class RegistrationSexSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentSex = context.select<RegistrationBloc, String>((bloc) {
      return bloc.state is RegistrationStepOne
          ? (bloc.state as RegistrationStepOne).sex
          : 'male';
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
            ),

            const SizedBox(width: X_MIN_WIDTH_SIZED_BOX * 4),

            _buildSexOption(
              context: context,
              title: 'Nữ',
              value: 'female',
              isSelected: currentSex == 'female',
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
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
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
                    : COLORS.INPUT_BG_COLOR,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected
                      ? COLORS.FOCUSED_BORDER_IP_COLOR
                      : COLORS.UNFOCUSED_BORDER_IP_COLOR,
              width: isSelected ? 1.5 : 0.7,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color:
                    isSelected
                        ? COLORS.PRIMARY_TEXT_COLOR
                        : COLORS.SECONDARY_TEXT_COLOR,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
