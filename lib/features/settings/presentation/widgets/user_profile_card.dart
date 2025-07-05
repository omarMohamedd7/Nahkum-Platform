import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/widgets/home_profile_image.dart';
import 'package:nahkum/features/auth/data/models/user/user_model.dart';

class UserProfileCard extends StatelessWidget {
  final VoidCallback onTap;

  const UserProfileCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final UserModel userModel =
        UserModel.fromJson(cache.read(CacheHelper.user));
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.edit,
              size: 20,
              color: Color(0xFFC8A45D),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  userModel.name,
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userModel.email,
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            const HomeProfileImage(),
          ],
        ),
      ),
    );
  }
}
