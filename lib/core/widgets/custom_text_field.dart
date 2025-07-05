import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/core/utils/responsive_utils.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final String? iconPath;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool isBordered;
  final bool readOnly;
  final void Function()? onTap;
  final bool isMultiline;
  final bool isNumeric;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.labelText,
    this.iconPath,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    required this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.isMultiline = false,
    this.isNumeric = false,
    this.validator,
    this.contentPadding,
    this.isBordered = false,
  }) : assert(
          iconPath != null ||
              prefixIcon != null ||
              (iconPath == null && prefixIcon == null),
          'Provide either iconPath or prefixIcon, not both',
        );

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final secondaryColor = const Color(0xFFBFBFBF);
    // Get responsive values
    final double fontSize = ResponsiveUtils.getFontSize(context, smallSize: 14);
    final double iconSize = ResponsiveUtils.getIconSize(context, smallSize: 18);
    final double fieldHeight = ResponsiveUtils.getInputFieldHeight(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelText!,
              style: AppStyles.labelText.copyWith(
                fontSize: fontSize + 1,
              ),
            ),
          ),
        Container(
          height: widget.isMultiline ? null : fieldHeight,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            controller: widget.controller,
            validator: widget.validator,
            obscureText: widget.isPassword ? _obscureText : false,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            maxLines: widget.isMultiline ? null : 1,
            keyboardType: widget.keyboardType ??
                (widget.isMultiline
                    ? TextInputType.multiline
                    : widget.isNumeric
                        ? TextInputType.number
                        : TextInputType.text),
            style: AppStyles.bodyMedium.copyWith(
              fontSize: fontSize,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppStyles.bodyMedium.copyWith(
                color: secondaryColor,
                fontSize: fontSize,
              ),
              prefixIcon: widget.iconPath != null
                  ? Padding(
                      padding: AppStyles.verticalPaddingMedium,
                      child: SvgPicture.asset(
                        widget.iconPath!,
                        color: AppColors.primary,
                        width: iconSize,
                        height: iconSize,
                      ),
                    )
                  : widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: AppColors.primary,
                          size: iconSize,
                        )
                      : null,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Padding(
                        padding: AppStyles.verticalPaddingMedium,
                        child: SvgPicture.asset(
                          _obscureText
                              ? AppAssets.eyeSlash
                              : AppAssets.eyeSlash,
                          color: secondaryColor,
                          width: iconSize,
                          height: iconSize,
                        ),
                      ),
                    )
                  : null,
              border: widget.isBordered
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  : InputBorder.none,
              contentPadding: widget.contentPadding ??
                  (widget.isMultiline
                      ? AppStyles.multilineInputFieldContentPadding
                      : EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: fieldHeight / 4,
                        )),
            ),
          ),
        ),
      ],
    );
  }
}
