import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Features/Splash/presentation/views/splash_view.dart';
import 'constants.dart';

void main() {
  runApp(const EmpApp());
}

class EmpApp extends StatelessWidget {
  const EmpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Current Theme Mode: ${Get.theme.brightness}');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kPrimaryColor,
        textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.light, // Initialize with system theme mode
      home: const SplashView(),
    );
  }
}
