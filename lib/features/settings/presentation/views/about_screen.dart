import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color primary = Color(0xFF181C3C);
  static const Color gold = Color(0xFFC8A45D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حول التطبيق',
          style: TextStyle(
            color: primary,
            fontFamily: 'Almarai',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
نَحْكُم هو تطبيق قانوني افتراضي يجمع بين العميل، المحامي، والقاضي في مكان رقمي واحد. يسمح برفع قضايا، توكيل محامين، وإجراء جلسات افتراضية.

مميزاته:
- تقديم قضايا وتوكيل محامين
- عروض قانونية من محامين
- جلسات قانونية افتراضية
- ذكاء اصطناعي لتحليل المصداقية

نَحْكُم هو مشروع تخرج أكاديمي يطمح ليكون نواة للعدالة الرقمية المستقبلية.
            ''',
            style: TextStyle(
              color: primary,
              fontSize: 16,
              fontFamily: 'Almarai',
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}
