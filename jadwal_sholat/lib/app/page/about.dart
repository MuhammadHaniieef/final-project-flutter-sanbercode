import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    const panelColor = Color(0xFF0F2D37); // latar gelap full
    const accent     = Color(0xFF7ED59C); // aksen hijau

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // back button putih otomatis
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Latar gelap full screen
          Container(color: panelColor),

          // Konten
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // aksen hijau atas
                      Container(
                        width: 72, height: 10,
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 200),

                      const Text(
                        'ABOUT ME',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const _CreditLine(
                        'Hai, nama saya Muhammad Hanief saya adalah seorang Electrical Engineering.',
                      ),
                      const SizedBox(height: 10),
                      const _CreditLine(
                        'Saya sedang bekerja di suatu perusahaan swasta, pekerjaan saya lebih kepada IoT developer.',
                      ),
                      const SizedBox(height: 10),
                      const _CreditLine(
                        'Alasan saya membuat aplikasi ini adalah agar saya dapat lebih mudah untuk mengingat waktu shalat terutama shalat 5 waktu.',
                      ),

                      const SizedBox(height: 200),

                      // aksen hijau bawah
                      Container(
                        width: 72, height: 10,
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditLine extends StatelessWidget {
  final String text;
  const _CreditLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        height: 1.5,
        fontSize: 14.5,
      ),
    );
  }
}
