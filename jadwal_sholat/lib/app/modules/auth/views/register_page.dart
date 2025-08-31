import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../../widgets/header_half_image.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/google_button.dart';
import '../../../routes/app_routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();

    final emailC = TextEditingController();
    final passC  = TextEditingController();
    final pass2C = TextEditingController();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderHalfImage(
                assetPath: 'assets/images/masjid-solo.jpg',
                heightFactor: 0.5,
                title: 'Jadwal Shalat Indonesia',
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Email
                    InputField(
                      hint: 'Email',
                      controller: emailC,
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    // Password
                    Obx(() => InputField(
                          hint: 'Password',
                          controller: passC,
                          obscure: c.obscurePassReg1.value,
                          onToggleObscure: () => c.obscurePassReg1.toggle(),
                        )),
                    const SizedBox(height: 12),

                    // Konfirmasi Password
                    Obx(() => InputField(
                          hint: 'Konfirmasi Password',
                          controller: pass2C,
                          obscure: c.obscurePassReg2.value,
                          onToggleObscure: () => c.obscurePassReg2.toggle(),
                        )),
                    const SizedBox(height: 12),

                    // Tombol daftar (pakai loadingReg)
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: c.loadingReg.value
                                ? null
                                : () {
                                    if (passC.text != pass2C.text) {
                                      Get.snackbar('Gagal', 'Password tidak sama');
                                      return;
                                    }
                                    c.register(emailC.text, passC.text);
                                  },
                            child: c.loadingReg.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Mendaftar'),
                          ),
                        )),
                    const SizedBox(height: 16),

                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Atau daftar menggunakan'),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Google register (pakai loadingGoogle)
                    Obx(() => GoogleButton(
                          onPressed: c.loadingGoogle.value
                              ? null
                              : () => c.googleRegisterFlow(),
                        )),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sudah punya akun? '),
                        GestureDetector(
                          onTap: () => Get.offAllNamed(Routes.login),
                          child: Text(
                            'Masuk',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
