import 'package:flutter/material.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button (only displayed when allowBack = true)
              if (allowBack)
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: IconSizes.ICON_HEADER_SIZE,
                  ),
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationStepOnePage(),
                        ),
                      ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  alignment: Alignment.centerLeft,
                ),

              // Icon
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.star_outlined,
                  color: COLORS.PRIMARY_APP_COLOR,
                  size: IconSizes.ICON_PAGE_SIZE,
                ),
              ),

              const SizedBox(height: MAX_HEIGTH_SIZED_BOX),
              const SizedBox(height: MAX_HEIGTH_SIZED_BOX),
              const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: HeaderSizes.HEADER_PAGE_TITLE,
                  fontWeight: FontWeight.w700,
                  color: COLORS.HEADER_PAGE_COLOR,
                ),
              ),

              const SizedBox(height: MAX_HEIGTH_SIZED_BOX),
              const SizedBox(height: MAX_HEIGTH_SIZED_BOX),

              // Child content
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
