import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/language.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/custom_error_screen.dart';
import 'app/routes/app_pages.dart';

Locale? loc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Get.putAsync(() => GetStorageProvider().init());
  final storage = Get.find<GetStorageProvider>();
  loc = await storage.readLocale();

  AudioPlayer.global.setAudioContext(
    const AudioContext(
      android: AudioContextAndroid(
        audioMode: AndroidAudioMode.ringtone,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.alarm,
        audioFocus: AndroidAudioFocus.gainTransient,
      ),
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(
    const UltimateAlarmClockApp(),
  );
}

class UltimateAlarmClockApp extends StatelessWidget {
  const UltimateAlarmClockApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: kLightThemeData,
      darkTheme: kThemeData,
      themeMode: ThemeMode.system,
      title: 'UltiClock',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: loc,
      fallbackLocale: const Locale('en', 'US'),
      builder: (BuildContext context, Widget? error) {
        ErrorWidget.builder = (FlutterErrorDetails? error) {
          return CustomErrorScreen(errorDetails: error!);
        };
        return error!;
      },
    );
  }
}
