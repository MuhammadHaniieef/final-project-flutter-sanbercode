import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../widgets/header_half_image.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/google_button.dart';
import '../../../routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AuthController(), permanent: true);

    final emailC = TextEditingController();
    final passC = TextEditingController();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderHalfImage(
                assetPath: 'assets/images/masjid_nabawi.jpg',
                heightFactor: 0.5,
                title: 'Jadwal Shalat Indonesia',
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    InputField(
                      hint: 'Email',
                      controller: emailC,
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    Obx(() => InputField(
                          hint: 'Password',
                          controller: passC,
                          obscure: c.obscurePassLogin.value,
                          onToggleObscure: () => c.obscurePassLogin.toggle(),
                        )),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Lupa password?'),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => c.login(emailC.text, passC.text),
                        child: const Text('Masuk'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Atau masuk menggunakan'),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 12),
                   GoogleButton(onPressed: () => c.googleLoginFlow()),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum punya akun? '),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.register),
                          child: Text(
                            'Mendaftar sekarang',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
