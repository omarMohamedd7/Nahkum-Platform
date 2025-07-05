import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final Widget icon;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double titleFontSize = screenWidth < 360 ? 14 : 16;
    final double descriptionFontSize = screenWidth < 360 ? 11 : 12;
    final double buttonFontSize = screenWidth < 360 ? 12 : 14;

    final double cardPadding = screenWidth < 360 ? 12 : 16;

    final double buttonWidth = screenWidth * 0.28;
    final double buttonHeight = screenWidth < 360 ? 28 : 32;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(200, 164, 93, 0.15),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: icon,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: descriptionFontSize,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
