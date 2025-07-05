import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/judge/presentation/widgets/notifications_button.dart';

class JudgeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JudgeAppBar({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      actions: [NotificationsButton()],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}
