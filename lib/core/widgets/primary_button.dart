// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../constants/others.dart';
import '../constants/sizes.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định xem nút có đang bị disable hay không
    final bool isDisabled = onPressed == null || isLoading;

    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   if (!isDisabled)
        //     BoxShadow(
        //       color: COLORS.PRIMARY_BUTTON_COLOR.withOpacity(0.3),
        //       blurRadius: 12,
        //       offset: const Offset(0, 4), // Tạo độ nổi (depth)
        //     ),
        // ],
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: COLORS.PRIMARY_BUTTON_COLOR,
          disabledBackgroundColor: COLORS.PRIMARY_BUTTON_COLOR.withOpacity(0.5),
          foregroundColor: Colors.white,
          minimumSize: Size(
            double.infinity,
            MediaQuery.sizeOf(context).height * 0.062,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation:
              2, // Sử dụng nếu không có thuộc tính boxShadow từ BoxDecoration
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Hiệu ứng loang khi nhấn (Ripple effect)
          // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: COLORS.PRIMARY_TEXT_COLOR),

                      const SizedBox(width: X_MIN_WIDTH_SIZED_BOX * 2),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        color: COLORS.PRIMARY_TEXT_COLOR,
                        fontSize: TextSizes.TITLE_MEDIUM,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.7, // Dùng để giãn chữ theo chiều ngang
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
