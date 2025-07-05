import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String notificationIconPath;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.notificationIconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFBFBFBF),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time on the left
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF737373),
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
                // Title + icon on the right
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Almarai',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    SvgPicture.asset(
                      notificationIconPath,
                      width: 18,
                      height: 18,
                      color: const Color(0xFFC8A45D),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF737373),
                fontFamily: 'Almarai',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
