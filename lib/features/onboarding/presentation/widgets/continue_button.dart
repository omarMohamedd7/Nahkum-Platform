import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double fontSize;
  final double height;

  const ContinueButton({
    super.key,
    required this.onPressed,
    required this.fontSize,
    required this.height,
  });

  static const Color goldColor = Color(0xFFC8A45D);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: goldColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: goldColor.withOpacity(0.5),
        disabledForegroundColor: Colors.white.withOpacity(0.7),
        minimumSize: Size(double.infinity, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'متابعة',
        style: TextStyle(
          fontFamily: 'Almarai',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
