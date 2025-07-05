import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nahkum/core/routes/app_pages.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/utils/fcm_service.dart';
import 'package:nahkum/core/utils/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initDependencies();

  // Initialize FCM service after dependency injection
  await injector<FcmService>().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print(cache.read(CacheHelper.fcmToken));
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: AppPages.routes,
          initialRoute: AppPages.initialRoute,
          themeMode: ThemeMode.light,
          locale: const Locale('en'),
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xffFAFAFA),
            colorScheme: ColorScheme.fromSeed(
              // ignore: deprecated_member_use
              background: const Color(0xFF181E3C),
              primary: const Color(0xFFC8A45D),
              seedColor: const Color(0xFFC8A45D),
            ),
            useMaterial3: true,
            fontFamily: 'Almarai',
          ),
        );
      },
    );
  }
}
