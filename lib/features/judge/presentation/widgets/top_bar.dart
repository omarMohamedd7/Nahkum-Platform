import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/widgets/home_profile_image.dart';
import 'package:nahkum/features/auth/data/models/user/user_model.dart';
import 'package:nahkum/features/judge/presentation/widgets/notifications_button.dart';

class JudgeHomeTopBar extends StatelessWidget {
  const JudgeHomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModel =
        UserModel.fromJson(cache.read(CacheHelper.user));
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth < 360 ? 13 : 14;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NotificationsButton(),
        Row(
          children: [
            Text(
              userModel.name,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF181E3C),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            const HomeProfileImage(),
          ],
        )
      ],
    );
  }
}
