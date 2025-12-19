import 'package:flutter/material.dart';

import '../constants/others.dart';
import '../constants/sizes.dart';
import 'logo.dart';

/*
  constraints: const BoxConstraints() trong IconButton là để bỏ kích thước mặc định của IconButton.
  👉 NÊN dùng khi:
    - Icon phụ
    - Icon trang trí
    - Icon trong form / list item

  Align là widget dùng để căn chỉnh vị trí của 1 widget con bên trong vùng không gian mà nó được cấp.
  👉 Align = đặt con ở đâu trong khung của cha

  BoxDecoration là gì?
  👉 Dùng để trang trí cho Container:
    - nền
    - bo góc
    - viền
    - đổ bóng

  BoxShadow dùng để làm gì?
  👉 Tạo bóng đổ (shadow) phía sau widget

  blurRadius là gì?
  📌 Độ mờ / độ lan của bóng
    - Giá trị càng lớn → bóng mềm, loang, nhẹ
    - Giá trị nhỏ → bóng gắt, sắc cạnh

  offset là gì?
  👉 Vị trí lệch của bóng so với widget
*/
class AuthenticationForm extends StatelessWidget {
  final Widget child;
  final bool allowBack;
  final String title;
  final VoidCallback? onBack;

  const AuthenticationForm({
    super.key,
    required this.child,
    this.allowBack = false,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.PRIMARY_BG_COLOR,
      body: SafeArea(
        child: Stack(
          children: [
            if (allowBack)
              Positioned(
                left: 15,
                top: MAX_HEIGTH_SIZED_BOX,
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 6),

                  Align(alignment: Alignment.center, child: Logo()),

                  const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 4),

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: HeaderSizes.HEADER_SECTION_TITLE,
                      fontWeight: FontWeight.w400,
                      color: COLORS.HEADER_PAGE_COLOR,
                    ),
                  ),

                  const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
