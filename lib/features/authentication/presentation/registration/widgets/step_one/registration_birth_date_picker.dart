import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/others.dart';
import '../../../../../../core/constants/sizes.dart';
import '../../bloc/bloc.dart';

class RegistrationBirthDatePicker extends StatelessWidget {
  const RegistrationBirthDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lấy thông tin từ state
    final birthDateStr = context.select<RegistrationBloc, String>((bloc) {
      final state = bloc.state;

      return state is RegistrationStepOne ? state.birthDate : '';
    });
    // 2. Lấy trạng thái Loading
    final bool isLoading = context.select<RegistrationBloc, bool>((bloc) {
      final state = bloc.state;

      return state is RegistrationStepOne && state.isLoading;
    });
    // 3. Logic xác định ngày để hiển thị
    final effectiveDate =
        birthDateStr.isNotEmpty
            ? DateTime.parse(birthDateStr)
            : DateTime(2000, 1, 1);
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
          // [QUAN TRỌNG] Nếu đang loading thì onTap = null -> Button bị vô hiệu hóa
          onTap:
              isLoading
                  ? null
                  : () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          effectiveDate, // Dùng ngày hiện tại đang chọn thay vì fix cứng 2000
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      final currentState =
                          context.read<RegistrationBloc>().state;

                      if (currentState is RegistrationStepOne) {
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
              // Đổi màu nền nhẹ nếu disabled (tùy chọn)
              color: isLoading ? Colors.grey.shade100 : COLORS.INPUT_BG_COLOR,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                // ignore: deprecated_member_use
                color: COLORS.UNFOCUSED_BORDER_IP_COLOR.withOpacity(
                  isLoading ? 0.5 : 1.0, // Làm mờ border khi loading
                ),
                width: 0.7,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color:
                      isLoading
                          ? Colors.grey.shade400
                          : COLORS.ICON_PRIMARY_COLOR,
                ),

                const SizedBox(width: X_MIN_WIDTH_SIZED_BOX * 3),

                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: TextSizes.TITLE_SMALL,
                    fontWeight: FontWeight.w500,
                    // Làm mờ text khi loading
                    color:
                        isLoading
                            ? Colors.grey.shade400
                            : (birthDateStr.isEmpty
                                ? COLORS.HINT_TEXT_COLOR
                                : COLORS.PRIMARY_TEXT_COLOR),
                  ),
                ),

                const Spacer(),

                // Logic hiển thị icon cuối hàng: Loading -> Spinner, Thường -> Mũi tên
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: COLORS.FOCUSED_BORDER_IP_COLOR,
                    ),
                  )
                else
                  Icon(Icons.arrow_drop_down, color: COLORS.ICON_PRIMARY_COLOR),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
