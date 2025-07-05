import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';

class LawyerBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const LawyerBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _NavItemData(
        activeIcon: AppAssets.activeHome,
        inactiveIcon: AppAssets.unactiveHome,
        fallbackIcon: Icons.home,
        label: 'الرئيسية',
        index: 0,
        onTap: () {
          if (currentIndex != 0) {
            Get.offAllNamed(Routes.LAWYER_HOME);
          }
        },
      ),
      // _NavItemData(
      //   activeIcon: 'assets/images/active lawyer bar/people.svg',
      //   inactiveIcon: 'assets/images/unactive Lawyer bar/people.svg',
      //   fallbackIcon: Icons.people,
      //   label: 'الموكلين',
      //   index: 1,
      //   onTap: () {
      //     if (currentIndex != 1) {
      //       Get.offAllNamed(Routes.LAWYER_CLIENTS);
      //     }
      //   },
      // ),
      _NavItemData(
        activeIcon: 'assets/images/active lawyer bar/judge.svg',
        inactiveIcon: 'assets/images/unactive Lawyer bar/judge.svg',
        fallbackIcon: Icons.gavel,
        label: 'قضاياي',
        index: 2,
        onTap: () {
          if (currentIndex != 2) {
            Get.offAllNamed(Routes.LAWYER_CASES);
          }
        },
      ),
      _NavItemData(
        activeIcon: 'assets/images/active lawyer bar/archive-book.svg',
        inactiveIcon: 'assets/images/unactive Lawyer bar/archive-book.svg',
        fallbackIcon: Icons.book,
        label: 'التوكيلات',
        index: 3,
        onTap: () {
          if (currentIndex != 3) {
            Get.offAllNamed(Routes.LAWYER_AGENCIES);
          }
        },
      ),
      _NavItemData(
        activeIcon: 'assets/images/active lawyer bar/note-add.svg',
        inactiveIcon: 'assets/images/unactive Lawyer bar/note-add.svg',
        fallbackIcon: Icons.note_add,
        label: 'طلباتي',
        index: 4,
        onTap: () {
          if (currentIndex != 4) {
            Get.offAllNamed(Routes.LAWYER_ORDERS);
          }
        },
      ),
    ];

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: navItems
              .map((item) => _buildNavItem(
                    context: context,
                    data: item,
                    isSelected: currentIndex == item.index,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required _NavItemData data,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: data.onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isSelected ? data.activeIcon : data.inactiveIcon,
              width: 24,
              height: 24,
              placeholderBuilder: (context) => Icon(
                data.fallbackIcon,
                size: 24,
                color: isSelected ? AppColors.gold : const Color(0xFFB8B8B8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                color: isSelected ? AppColors.gold : const Color(0xFFB8B8B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final String activeIcon;
  final String inactiveIcon;
  final IconData fallbackIcon;
  final String label;
  final int index;
  final VoidCallback onTap;

  _NavItemData({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.fallbackIcon,
    required this.label,
    required this.index,
    required this.onTap,
  });
}
