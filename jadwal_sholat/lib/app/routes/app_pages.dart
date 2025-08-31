import 'package:get/get.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/register_page.dart';
import '../page/select_page.dart';   // <— path sesuai yang kamu buat
import 'app_routes.dart';
import '../page/show.dart';
import '../page/about.dart';  

class AppPages {
  static const initial = Routes.login;

  static final routes = <GetPage>[
    GetPage(name: Routes.login,    page: () => const LoginPage()),
    GetPage(name: Routes.register, page: () => const RegisterPage()),
    GetPage(name: Routes.select,   page: () => const SelectPage()), 
    GetPage(name: Routes.jadwal, page: () => const ShowPage()),
    GetPage(name: Routes.about,    page: () => const AboutPage()),
    // GetPage(name: Routes.lokasi, page: () => const LokasiPage()),
    // GetPage(name: Routes.jadwal, page: () => const JadwalPage()),
  ];
}
