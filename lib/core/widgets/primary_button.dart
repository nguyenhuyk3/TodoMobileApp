import 'package:flutter/material.dart';

import '../constants/others.dart';
import '../constants/sizes.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          COLORS.PRIMARY_APP_COLOR,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Colors.transparent, width: 1),
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, MediaQuery.of(context).size.height * 0.06),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          title,
          style: TextStyle(
            color: COLORS.PRIMARY_TEXT_COLOR,
            fontSize: TextSizes.TITLE_MEDIUM,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
