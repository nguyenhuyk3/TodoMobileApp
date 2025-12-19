import 'package:flutter/material.dart';
import 'package:todo_mobile_app/core/widgets/logo.dart';

import '../../features/authentication/registration/presentation/pages/step_one.dart';
import '../constants/others.dart';
import '../constants/sizes.dart';

/*
  constraints: const BoxConstraints() trong IconButton là để bỏ kích thước mặc định của IconButton.
  👉 NÊN dùng khi:
    - Icon phụ
    - Icon trang trí
    - Icon trong form / list item

  Align là widget dùng để căn chỉnh vị trí của 1 widget con bên trong vùng không gian mà nó được cấp.
  👉 Align = đặt con ở đâu trong khung của cha
*/
class AuthenticationForm extends StatelessWidget {
  final Widget child;
  final bool allowBack;
  final String title;

  const AuthenticationForm({
    super.key,
    required this.child,
    this.allowBack = false,
    required this.title,
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
                left: 10,
                top: MIN_HEIGHT_SIZED_BOX,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: IconSizes.ICON_HEADER_SIZE,
                    color: COLORS.ICON_PRIMARY_COLOR,
                  ),
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegistrationStepOnePage(),
                        ),
                      ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 5),

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

                  const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 2),

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
