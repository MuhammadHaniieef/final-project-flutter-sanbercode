import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/provinsi.dart';
import '../../data/kota.dart';
import '../../routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectLocationController extends GetxController {
  final country = 'Indonesia'.obs;

  // dropdown provinsi
  final provinces = <String>[...kProvinceNames].obs;

  // pilihan saat ini
  final selectedProvinceName = RxnString();
  final selectedCity = RxnString();

  // list kota yang tampil
  final cities = <String>[].obs;

  // ====== TANGGAL ======
  final selectedDate = DateTime.now().obs;
  String get formattedDate {
    final d = selectedDate.value;
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y/$m/$day'; // cocok untuk path API
  }

  Future<void> pickDate(BuildContext context) async {
    final initial = selectedDate.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) selectedDate.value = picked;
  }
  // ======================

  String? get selectedProvinceCode {
    final name = selectedProvinceName.value;
    if (name == null) return null;
    return kProvinceNameToCode[name];
  }

  void onProvinceChanged(String? v) {
    selectedProvinceName.value = v;
    selectedCity.value = null;

    final provCode = selectedProvinceCode;
    if (provCode == null) {
      cities.clear();
      return;
    }
    cities.assignAll(cityNamesOfProvCode(provCode));
  }

  Future<void> onConfirm() async {
    final provName = selectedProvinceName.value;
    final provCode = selectedProvinceCode;
    final cityName = selectedCity.value;

    if (provName == null || provCode == null || cityName == null) {
      Get.snackbar('Lokasi belum lengkap', 'Pilih provinsi dan kota/kabupaten.');
      return;
    }

    final kotaId = cityIdByProvAndName(provCode, cityName);
    if (kotaId == null) {
      Get.snackbar('Data tidak valid', 'ID kota untuk "$cityName" tidak ditemukan.');
      return;
    }

    Get.toNamed(
      Routes.jadwal,
      arguments: {
        'kotaId': kotaId,
        'provinsi': provName,
        'kota': cityName,
        'dateIso': selectedDate.value.toIso8601String(),
        'ymdPath': formattedDate,
      },
    );
  }

  // ==== LOGOUT ====
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.login);
  }
}