import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A centralized place for reusable styles throughout the application.
class AppStyles {
  /// Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Almarai',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Almarai',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'Almarai',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Almarai',
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Almarai',
    fontSize: 15,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Almarai',
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle captionText = TextStyle(
    fontFamily: 'Almarai',
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Almarai',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.white,
  );

  static const TextStyle labelText = TextStyle(
    fontFamily: 'Almarai',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.primary,
  );

  /// EdgeInsets
  static const EdgeInsets paddingSmall = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(24.0);

  static const EdgeInsets horizontalPaddingSmall =
      EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets horizontalPaddingMedium =
      EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets horizontalPaddingLarge =
      EdgeInsets.symmetric(horizontal: 24.0);

  static const EdgeInsets verticalPaddingSmall =
      EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets verticalPaddingMedium =
      EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets verticalPaddingLarge =
      EdgeInsets.symmetric(vertical: 24.0);

  static const EdgeInsets inputFieldContentPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
  static const EdgeInsets multilineInputFieldContentPadding =
      EdgeInsets.all(16.0);

  /// BorderRadius
  static final BorderRadius radiusSmall = BorderRadius.circular(4.0);
  static final BorderRadius radiusMedium = BorderRadius.circular(8.0);
  static final BorderRadius radiusLarge = BorderRadius.circular(12.0);
  static final BorderRadius radiusXLarge = BorderRadius.circular(24.0);
  static final BorderRadius radiusCircular = BorderRadius.circular(100.0);

  /// BoxShadow
  static const List<BoxShadow> shadowLight = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowHeavy = [
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  /// BoxDecorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: radiusMedium,
    boxShadow: shadowLight,
  );

  static BoxDecoration elevatedContainerDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: radiusMedium,
    boxShadow: shadowMedium,
  );

  static BoxDecoration inputFieldDecoration = BoxDecoration(
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.inputBorder),
    color: AppColors.inputBackground,
  );

  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: AppColors.primary,
    borderRadius: radiusMedium,
  );

  static BoxDecoration outlinedButtonDecoration = BoxDecoration(
    color: Colors.transparent,
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.primary, width: 1.0),
  );

  static BoxDecoration roundedProfileImage = BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.grey[300],
  );

  static BoxDecoration editProfileButton = BoxDecoration(
    shape: BoxShape.circle,
    color: AppColors.primary,
  );
}
