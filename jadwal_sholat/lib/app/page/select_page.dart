import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/location/select_location_controller.dart';
import 'package:flutter/services.dart'; // untuk status bar icon putih kalau perlu

class SelectPage extends GetView<SelectLocationController> {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SelectLocationController>()) {
      Get.put(SelectLocationController(), permanent: true);
    }

    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true, // biar AppBar transparan di atas gambar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Pilih Lokasi', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            onPressed: controller.logout,
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header gambar
              SizedBox(
                height: h / 3,
                child: Image.asset('assets/images/masjidil_haram.jpg', fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assalamualaikum ahli surga,\nSilahkan pilih lokasi anda saat ini',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),

                    // Negara (fix Indonesia)
                    Obx(() => DropdownButtonFormField<String>(
                          value: controller.country.value,
                          decoration: const InputDecoration(
                            labelText: 'Negara',
                            border: OutlineInputBorder(),
                          ),
                          items: const [DropdownMenuItem(value: 'Indonesia', child: Text('Indonesia'))],
                          onChanged: null,
                        )),
                    const SizedBox(height: 14),

                    // Provinsi
                    Obx(() => DropdownButtonFormField<String>(
                          value: controller.selectedProvinceName.value,
                          decoration: const InputDecoration(
                            labelText: 'Provinsi',
                            border: OutlineInputBorder(),
                          ),
                          items: controller.provinces
                              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                              .toList(),
                          onChanged: (v) => controller.onProvinceChanged(v),
                        )),
                    const SizedBox(height: 14),

                    // Kota / Kabupaten
                    Obx(() => DropdownButtonFormField<String>(
                          value: controller.selectedCity.value,
                          decoration: const InputDecoration(
                            labelText: 'Kota / Kabupaten',
                            border: OutlineInputBorder(),
                          ),
                          items: controller.cities
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: controller.cities.isEmpty ? null : (v) => controller.selectedCity.value = v,
                        )),
                    const SizedBox(height: 14),

                    // Tanggal
                    Obx(() => InkWell(
                          onTap: () => controller.pickDate(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Tanggal',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(controller.formattedDate),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        )),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.onConfirm,
                        child: const Text('Konfirmasi'),
                      ),
                    ),
                    const SizedBox(height: 20),
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
