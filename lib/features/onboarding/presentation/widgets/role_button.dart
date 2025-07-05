import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/user_role.dart';

class RoleButton extends StatelessWidget {
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleButton({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  static const Color goldColor = Color(0xFFC8A45D);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        padding: EdgeInsets.symmetric(vertical: 15.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? goldColor : Colors.transparent,
          border: isSelected ? null : Border.all(color: goldColor),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          role.getArabicName(),
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : goldColor,
          ),
        ),
      ),
    );
  }
}
