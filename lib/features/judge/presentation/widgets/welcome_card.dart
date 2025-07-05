import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nahkum/core/utils/app_assets.dart';

class JudgeWelcomeSection extends StatelessWidget {
  const JudgeWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth < 360 ? 22 : 24;
    final double textFontSize = screenWidth < 360 ? 13 : 14;
    final double logoWidth = screenWidth * 0.15;
    final double logoHeight = logoWidth * 1.24;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: double.infinity,
        height: screenWidth * 0.42,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset('assets/images/judge_slider.png',
                      fit: BoxFit.fill)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenWidth * 0.05,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF181E3C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.mainLogo,
                      width: logoWidth,
                      height: logoHeight,
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'نحكم',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.025),
                          Text(
                            'أداتك الذكية لتحليل القضايا بدقة و تنظيم مهامك القانونية بكفاءة عالية.',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: textFontSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
