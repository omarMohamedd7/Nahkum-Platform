import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const Color primary = Color(0xFF181C3C);
  static const Color gold = Color(0xFFC8A45D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'سياسة الخصوصية',
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
نحن في تطبيق نَحْكُم نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. عند استخدامك للتطبيق، فإنك توافق على جمع واستخدام المعلومات كما هو موضح في هذه السياسة.

- المعلومات التي نجمعها تشمل الاسم، البريد، الهاتف، المدينة، التخصص، تسجيلات صوتية ومرئية، وتحليلات الذكاء الاصطناعي.
- تُستخدم البيانات لتقديم الخدمات، وتحسين الأداء، ودعم القاضي بتحليلات السلوك.
- لا تُشارك بياناتك مع أطراف خارجية، وتُمنح صلاحيات الاطلاع فقط للأطراف المرتبطة بالقضية.
- الذكاء الاصطناعي يحلل النص، الصوت، والصورة، ويُخزن التحليل كأداة داعمة للقاضي.
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
