import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/modules/auth/controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SholatApp());
}

class SholatApp extends StatelessWidget {
  const SholatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jadwal Sholat',
      theme: AppTheme.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // <- penting: supaya AuthController tersedia di Login/Register
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),
    );
  }
}
