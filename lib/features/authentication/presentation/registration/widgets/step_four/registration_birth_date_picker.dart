import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../bloc/bloc.dart';

class RegistrationBirthDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Lấy ngày sinh từ state
    // birthDateStr có định dạng ISO 8601: YYYY-MM-DDTHH:MM:SS.mmmuuuZ
    final birthDateStr = context.select<RegistrationBloc, String>((bloc) {
      final state = bloc.state;

      return state is RegistrationStepFour ? state.birthDate : '';
    });
    // 2. Logic xác định ngày để hiển thị
    // Nếu birthDateStr rỗng, ta sử dụng fallback là 2000-01-01
    final effectiveDate =
        birthDateStr.isNotEmpty
            ? DateTime.parse(birthDateStr)
            : DateTime(2000, 1, 1);
    // Chuyển về định dạng mà người Việt hay sử dụng là DD/MM/YYYY để hiển thị lên UI
    final formattedDate =
        "${effectiveDate.day.toString().padLeft(2, '0')}/"
        "${effectiveDate.month.toString().padLeft(2, '0')}/"
        "${effectiveDate.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Ngày sinh",
            style: TextStyle(
              color: COLORS.LABEL_COLOR,
              fontWeight: FontWeight.bold,
              fontSize: TextSizes.TITLE_XX_SMALL,
            ),
          ),
        ),

        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );

            if (picked != null) {
              final currentState = context.read<RegistrationBloc>().state;

              // picked = YYYY-MM-DD HH:MM:SS.mmmuuuZ, ex: 2000-01-20 00:00:00.000
              // picked.toIso8601String() = YYYY-MM-DDTHH:MM:SS.mmmuuuZ ex: 2000-01-20T00:00:00.000

              if (currentState is RegistrationStepFour) {
                context.read<RegistrationBloc>().add(
                  RegistrationInformationChanged(
                    fullName: currentState.fullName,
                    birthDate: picked.toIso8601String(),
                    sex: currentState.sex,
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: COLORS.INPUT_BG_COLOR,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: COLORS.UNFOCUSED_BORDER_IP_COLOR,
                width: 0.7,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: COLORS.ICON_PRIMARY_COLOR,
                ),

                const SizedBox(width: X_MIN_WIDTH_SIZED_BOX * 3),

                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: TextSizes.TITLE_SMALL,
                    color:
                        birthDateStr.isEmpty
                            ? COLORS.HINT_TEXT_COLOR
                            : COLORS.PRIMARY_TEXT_COLOR,
                  ),
                ),

                const Spacer(),

                Icon(Icons.arrow_drop_down, color: COLORS.ICON_PRIMARY_COLOR),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
