import 'package:flutter/material.dart';

/// A utility class for responsive design in the app
class ResponsiveUtils {
  /// Private constructor to prevent instantiation
  ResponsiveUtils._();

  /// Screen size breakpoints
  static const double _smallScreenWidth = 360;
  static const double _mediumScreenWidth = 480;

  /// Check if the screen is small (< 360px width)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < _smallScreenWidth;
  }

  /// Check if the screen is medium (between 360px and 480px width)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _smallScreenWidth && width < _mediumScreenWidth;
  }

  /// Check if the screen is large (>= 480px width)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= _mediumScreenWidth;
  }

  /// Get appropriate font size based on screen size
  /// [smallSize]: font size for small screens
  /// [mediumSize]: font size for medium screens (default is smallSize + 1)
  /// [largeSize]: font size for large screens (default is mediumSize + 1)
  static double getFontSize(
    BuildContext context, {
    required double smallSize,
    double? mediumSize,
    double? largeSize,
  }) {
    if (isSmallScreen(context)) {
      return smallSize;
    } else if (isMediumScreen(context)) {
      return mediumSize ?? smallSize + 1;
    } else {
      return largeSize ?? (mediumSize ?? smallSize + 1) + 1;
    }
  }

  /// Get appropriate padding based on screen size
  /// [smallPadding]: padding for small screens
  /// [mediumPadding]: padding for medium screens (default is smallPadding + 4)
  /// [largePadding]: padding for large screens (default is mediumPadding + 4)
  static double getPadding(
    BuildContext context, {
    required double smallPadding,
    double? mediumPadding,
    double? largePadding,
  }) {
    if (isSmallScreen(context)) {
      return smallPadding;
    } else if (isMediumScreen(context)) {
      return mediumPadding ?? smallPadding + 4;
    } else {
      return largePadding ?? (mediumPadding ?? smallPadding + 4) + 4;
    }
  }

  /// Get appropriate icon size based on screen size
  /// [smallSize]: icon size for small screens
  /// [mediumSize]: icon size for medium screens (default is smallSize + 2)
  /// [largeSize]: icon size for large screens (default is mediumSize + 2)
  static double getIconSize(
    BuildContext context, {
    required double smallSize,
    double? mediumSize,
    double? largeSize,
  }) {
    if (isSmallScreen(context)) {
      return smallSize;
    } else if (isMediumScreen(context)) {
      return mediumSize ?? smallSize + 2;
    } else {
      return largeSize ?? (mediumSize ?? smallSize + 2) + 2;
    }
  }

  /// Get appropriate button height based on screen size
  static double getButtonHeight(BuildContext context) {
    if (isSmallScreen(context)) {
      return 44.0;
    } else if (isMediumScreen(context)) {
      return 48.0;
    } else {
      return 52.0;
    }
  }

  /// Get appropriate input field height based on screen size
  static double getInputFieldHeight(BuildContext context) {
    if (isSmallScreen(context)) {
      return 46.0;
    } else if (isMediumScreen(context)) {
      return 50.0;
    } else {
      return 54.0;
    }
  }

  /// Get percentage of screen width
  static double getWidthPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  /// Get percentage of screen height
  static double getHeightPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }
}
