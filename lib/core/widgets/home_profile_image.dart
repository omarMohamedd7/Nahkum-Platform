import 'package:flutter/material.dart';
import 'package:nahkum/core/data/data_consts.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/features/auth/data/models/models.dart';

class HomeProfileImage extends StatelessWidget {
  const HomeProfileImage({
    super.key, 
  });
 

  @override
  Widget build(BuildContext context) {
    final UserModel userModel =
        UserModel.fromJson(cache.read(CacheHelper.user));
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: CircleAvatar(
        backgroundImage: (userModel.profileImageUrl ?? '').isEmpty
            ? null
            : NetworkImage(
                '${DataConsts.domain}/${userModel.profileImageUrl}',
              ),
        child: (userModel.profileImageUrl ?? '').isNotEmpty
            ? null
            : Text(userModel.name[0]),
      ),
    );
  }
}
