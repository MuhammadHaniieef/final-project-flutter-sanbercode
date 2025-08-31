import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback? onPressed; // nullable, bisa disable saat loading
  const GoogleButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        'assets/images/google.png', // <- path yang benar
        width: 20,
        height: 20,
        errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata),
      ),
      label: const Text('Lanjut dengan Google'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
