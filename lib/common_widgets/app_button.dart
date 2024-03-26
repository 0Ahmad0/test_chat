import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.onPressed,
      required this.text, this.icon,
      });

  final VoidCallback onPressed;
  final String text;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        minimumSize: const Size(double.infinity, 50.0)
      ),
        onPressed: onPressed,
        icon: icon ?? const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white
          ),
        ));
  }
}
