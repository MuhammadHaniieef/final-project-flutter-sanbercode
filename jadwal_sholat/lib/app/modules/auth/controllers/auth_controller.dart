import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn(); // 1 instance biar konsisten

  // obscure states (dipakai di UI)
  final obscurePassLogin = true.obs;
  final obscurePassReg1  = true.obs;
  final obscurePassReg2  = true.obs;

  // loading states (opsional untuk disable tombol)
  final loadingLogin  = false.obs;
  final loadingReg    = false.obs;
  final loadingGoogle = false.obs;

  // ================= EMAIL/PASSWORD =================
  Future<void> login(String email, String pass) async {
    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar('Gagal', 'Email dan password tidak boleh kosong');
      return;
    }
    try {
      loadingLogin.value = true;
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: pass.trim());
      Get.offAllNamed(Routes.select);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login gagal', _mapAuthError(e));
    } catch (e) {
      Get.snackbar('Login gagal', e.toString());
    } finally {
      loadingLogin.value = false;
    }
  }

  /// Register manual TANPA verifikasi email (langsung bisa dipakai)
  Future<void> register(String email, String pass) async {
    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar('Gagal', 'Email dan password tidak boleh kosong');
      return;
    }
    if (pass.length < 6) {
      Get.snackbar('Gagal', 'Password minimal 6 karakter');
      return;
    }
    try {
      loadingReg.value = true;
      await _auth.createUserWithEmailAndPassword(email: email.trim(), password: pass.trim());
      Get.offAllNamed(Routes.select);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Register gagal', _mapAuthError(e));
    } catch (e) {
      Get.snackbar('Register gagal', e.toString());
    } finally {
      loadingReg.value = false;
    }
  }

  // ================= GOOGLE SIGN-IN =================
  Future<void> googleRegisterFlow() => _googleFlow(isRegister: true);
  Future<void> googleLoginFlow()    => _googleFlow(isRegister: false);

  Future<void> _googleFlow({required bool isRegister}) async {
    try {
      loadingGoogle.value = true;

      // bersihkan sesi google sebelumnya
      try { await _google.signOut(); } catch (_) {}

      final gUser = await _google.signIn();
      if (gUser == null) return; // user cancel

      final gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final isBaru = result.additionalUserInfo?.isNewUser ?? false;

      if (isRegister && !isBaru) {
        // user menekan "Daftar dengan Google" tapi akunnya sudah ada
        await _safeSignOut();
        Get.offAllNamed(Routes.login);
        Get.snackbar('Akun sudah terdaftar', 'Silakan login menggunakan Google.');
        return;
      }
      if (!isRegister && isBaru) {
        // user menekan "Masuk dengan Google" tapi akunnya belum ada
        await _safeSignOut();
        Get.offAllNamed(Routes.register);
        Get.snackbar('Akun belum terdaftar', 'Silakan daftar terlebih dahulu.');
        return;
      }

      Get.offAllNamed(Routes.select);
    } on FirebaseAuthException catch (e) {
      // tampilkan kode + hint umum (mis. DEVELOPER_ERROR => SHA-1/256)
      final msg = _mapAuthError(e);
      Get.snackbar('Google Sign-In gagal', msg);
      // ignore: avoid_print
      print('Google Sign-In FirebaseAuthException: ${e.code} -> ${e.message}');
    } catch (e) {
      Get.snackbar('Google Sign-In gagal', e.toString());
      // ignore: avoid_print
      print('Google Sign-In error: $e');
    } finally {
      loadingGoogle.value = false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    try { await _google.signOut(); } catch (_) {}
    try { await _auth.signOut(); } catch (_) {}
    Get.offAllNamed(Routes.login);
  }

  // ================= Helpers =================
  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'weak-password':
        return 'Password terlalu lemah.';
      case 'network-request-failed':
        return 'Jaringan bermasalah. Periksa koneksi Anda.';
      case 'account-exists-with-different-credential':
        return 'Email sudah terhubung dengan metode lain.';
      case 'popup-closed-by-user':
      case 'canceled':
        return 'Proses dibatalkan.';
      case 'developer-error':
        // biasanya karena SHA-1/256 belum ditambahkan & belum download ulang google-services.json
        return 'Konfigurasi Google Sign-In belum benar (cek SHA-1/SHA-256 & google-services.json).';
      default:
        return '(${e.code}) ${e.message ?? "Terjadi kesalahan."}';
    }
  }

  Future<void> _safeSignOut() async {
    try { await _google.signOut(); } catch (_) {}
    try { await _auth.signOut(); } catch (_) {}
  }
}
