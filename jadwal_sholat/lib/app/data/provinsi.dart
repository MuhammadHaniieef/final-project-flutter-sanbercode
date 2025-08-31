// lib/app/data/provinsi.dart

class Province {
  final String kode; // "01" .. "34"
  final String nama;
  const Province({required this.kode, required this.nama});
}

const List<Province> kProvinces = [
  Province(kode: '01', nama: 'Aceh'),
  Province(kode: '02', nama: 'Sumatera Utara'),
  Province(kode: '03', nama: 'Sumatera Barat'),
  Province(kode: '04', nama: 'Riau'),
  Province(kode: '05', nama: 'Kepulauan Riau'),
  Province(kode: '06', nama: 'Jambi'),
  Province(kode: '07', nama: 'Bengkulu'),
  Province(kode: '08', nama: 'Sumatera Selatan'),
  Province(kode: '09', nama: 'Kep. Bangka Belitung'),
  Province(kode: '10', nama: 'Lampung'),
  Province(kode: '11', nama: 'Banten'),
  Province(kode: '12', nama: 'Jawa Barat'),
  Province(kode: '13', nama: 'DKI Jakarta'),
  Province(kode: '14', nama: 'Jawa Tengah'),
  Province(kode: '15', nama: 'DI Yogyakarta'),
  Province(kode: '16', nama: 'Jawa Timur'),
  Province(kode: '17', nama: 'Bali'),
  Province(kode: '18', nama: 'Nusa Tenggara Barat'),
  Province(kode: '19', nama: 'Nusa Tenggara Timur'),
  Province(kode: '20', nama: 'Kalimantan Barat'),
  Province(kode: '21', nama: 'Kalimantan Selatan'),
  Province(kode: '22', nama: 'Kalimantan Tengah'),
  Province(kode: '23', nama: 'Kalimantan Timur'),
  Province(kode: '24', nama: 'Kalimantan Utara'),
  Province(kode: '25', nama: 'Gorontalo'),
  Province(kode: '26', nama: 'Sulawesi Selatan'),
  Province(kode: '27', nama: 'Sulawesi Tenggara'),
  Province(kode: '28', nama: 'Sulawesi Tengah'),
  Province(kode: '29', nama: 'Sulawesi Utara'),
  Province(kode: '30', nama: 'Sulawesi Barat'),
  Province(kode: '31', nama: 'Maluku'),
  Province(kode: '32', nama: 'Maluku Utara'),
  Province(kode: '33', nama: 'Papua'),
  Province(kode: '34', nama: 'Papua Barat'),
];

// helper untuk dropdown (JANGAN const)
final List<String> kProvinceNames =
    kProvinces.map((p) => p.nama).toList(growable: false);

// mapping cepat (final saja)
final Map<String, String> kProvinceNameToCode = {
  for (final p in kProvinces) p.nama: p.kode
};
final Map<String, String> kProvinceCodeToName = {
  for (final p in kProvinces) p.kode: p.nama
};
