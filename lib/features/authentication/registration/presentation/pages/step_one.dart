// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/sizes.dart';
import '../../../../../core/widgets/authentication_form.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../bloc/bloc.dart';
import '../widgets/step_one/email_input.dart';

class RegistrationStepOnePage extends StatelessWidget {
  const RegistrationStepOnePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tại sao dùng WidgetsBinding.instance.addPostFrameCallback?

    // 1. TRÁNH LỖI "Build scheduled during frame":
    // Flutter cấm việc gọi các hàm làm thay đổi State (như add một Bloc Event dẫn đến emit state mới)
    // ngay trực tiếp trong khi hàm build đang chạy. Nếu bạn gọi trực tiếp context.read().add(),
    // Flutter sẽ báo lỗi vì nó đang bận vẽ UI, không thể xử lý logic thay đổi state cùng lúc đó.

    // 2. CHỜ FRAME HÌNH ĐẦU TIÊN VẼ XONG:
    // Hàm này đảm bảo đoạn code bên trong chỉ chạy NGAY SAU KHI widget này đã được
    // vẽ thành công lên màn hình. Lúc này luồng build đã rảnh, bạn có thể thực hiện
    // các logic chuyển trang hoặc cập nhật dữ liệu mà không gây xung đột.

    // 3. KHỞI TẠO DỮ LIỆU BAN ĐẦU:
    // Chúng ta muốn đảm bảo khi người dùng vừa vào trang "Đăng ký", Email sẽ được reset về trống.
    // Việc check "state is RegistrationInitial" giúp tránh việc mỗi lần UI build lại (do gõ phím)
    // thì email lại bị reset (vì addPostFrameCallback sẽ chạy sau mỗi lần build).
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<RegistrationBloc>().state is RegistrationInitial) {
        context.read<RegistrationBloc>().add(
          const RegistrationEmailChanged(email: ''),
        );
      }
    });

    return AuthenticationForm(
      title: 'Đăng ký',
      allowBack: true,
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationStepTwo) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<RegistrationBloc>(),
                      child: const RegistrationStepOnePage(),
                    ),
              ),
            );
          }
        },
        child: Column(
          children: [
            const EmailInput(),

            const Spacer(),

            Builder(
              builder: (context) {
                final state = context.watch<RegistrationBloc>().state;
                final isLoading = state is RegistrationLoading;

                return PrimaryButton(
                  title: 'Gửi mã xác thực OTP',
                  isLoading: isLoading,
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            context.read<RegistrationBloc>().add(
                              RegistrationEmailSubmitted(),
                            );
                          },
                );
              },
            ),

            const SizedBox(height: MAX_HEIGTH_SIZED_BOX * 3),
          ],
        ),
      ),
    );
  }
}
