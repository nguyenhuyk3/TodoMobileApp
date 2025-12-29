import 'package:flutter/material.dart';

import '../constants/others.dart';
import '../constants/sizes.dart';
import 'logo.dart';

class LongAuthenticationForm extends StatelessWidget {
  final Widget child;
  final bool allowBack;
  final String title;
  final bool resizeToAvoidBottomInset;
  final bool showLogo;
  final VoidCallback? onBack;

  const LongAuthenticationForm({
    super.key,
    required this.child,
    this.allowBack = false,
    this.showLogo = false,
    required this.title,
    // Thông thường True là tốt nhất để Scaffold tự xử lý padding bàn phím
    this.resizeToAvoidBottomInset = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true để giao diện tự co lên khi phím hiện
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: COLORS.PRIMARY_BG_COLOR,
      body: SafeArea(
        child: Stack(
          children: [
            // --- 1. PHẦN NỘI DUNG CHÍNH (CHO PHÉP CUỘN) ---
            Positioned.fill(
              child: SingleChildScrollView(
                // Khi chạm và kéo sẽ tắt bàn phím
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Khoảng trống để tránh đè lên nút Back
                      SizedBox(
                        height: MAX_HEIGTH_SIZED_BOX * (allowBack ? 5 : 2),
                      ),

                      if (showLogo)
                        Align(alignment: Alignment.center, child: Logo()),

                      const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 3),

                      Text(
                        title,
                        style: TextStyle(
                          fontSize: HeaderSizes.HEADER_SECTION_TITLE,
                          fontWeight: FontWeight.w400,
                          color: COLORS.HEADER_PAGE_COLOR,
                        ),
                      ),

                      const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

                      // Bỏ Expanded đi, chỉ cần render child
                      child,

                      // Khoảng trống dưới cùng
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // --- 2. NÚT BACK (CỐ ĐỊNH, KHÔNG CUỘN THEO NỘI DUNG) ---
            if (allowBack)
              Positioned(
                left: 15,
                top: 15, // Cố định vị trí
                child: InkWell(
                  onTap: onBack ?? () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: COLORS.PRIMARY_BG_COLOR,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: IconSizes.ICON_HEADER_SIZE,
                      color: COLORS.ICON_PRIMARY_COLOR,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
