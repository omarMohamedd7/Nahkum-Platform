import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/core/utils/responsive_utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final bool outlined;
  final Color? backgroundColor;
  final Color? textColor;
  final String? leadingIconPath;
  final double? height;
  final double? width;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.outlined = false,
    this.backgroundColor,
    this.textColor,
    this.leadingIconPath,
    this.height,
    this.width,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final buttonBackgroundColor =
        backgroundColor ?? (outlined ? Colors.transparent : AppColors.primary);
    final buttonTextColor =
        textColor ?? (outlined ? AppColors.primary : AppColors.white);

    // Get responsive values
    final double buttonHeight =
        height ?? ResponsiveUtils.getButtonHeight(context);
    final double fontSize = ResponsiveUtils.getFontSize(context, smallSize: 14);
    final double iconSize = ResponsiveUtils.getIconSize(context, smallSize: 20);
    final double loaderSize =
        ResponsiveUtils.getFontSize(context, smallSize: 16);

    return SizedBox(
      height: buttonHeight,
      width: width ?? double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            decoration: outlined
                ? AppStyles.outlinedButtonDecoration
                : BoxDecoration(
                    color: buttonBackgroundColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIconPath != null) ...[
                  SvgPicture.asset(
                    leadingIconPath!,
                    height: iconSize,
                    width: iconSize,
                  ),
                  SizedBox(
                      width: ResponsiveUtils.getWidthPercentage(context, 2)),
                ],
                if (isLoading)
                  SizedBox(
                    height: loaderSize,
                    width: loaderSize,
                    child: CircularProgressIndicator(
                      color: buttonTextColor,
                      strokeWidth:
                          ResponsiveUtils.isSmallScreen(context) ? 1.5 : 2.0,
                    ),
                  )
                else
                  Text(
                    text,
                    style: AppStyles.buttonText.copyWith(
                      color: buttonTextColor,
                      fontSize: fontSize,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
