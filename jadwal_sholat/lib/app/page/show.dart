import 'dart:async';
import 'dart:convert';
import 'dart:ui' show FontFeature; // <- untuk tabular figures
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../routes/app_routes.dart';

class ShowPage extends StatefulWidget {
  const ShowPage({super.key});

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  late final String kotaId;     // ex: "1301"
  late final String provinsi;   // ex: "DKI Jakarta"
  late final String kota;       // ex: "KOTA JAKARTA"
  late final String ymdPath;    // "YYYY/MM/DD"
  late final DateTime date;     // selected date

  Map<String, String>? jadwal;  // jam sholat (string "HH:MM")
  String? tanggalLabel;         // "Senin, 25/08/2025"
  Timer? _ticker;

  // urutan tampilan + label
  final List<MapEntry<String, String>> _keys = const [
    MapEntry('imsak',   'Imsak'),
    MapEntry('subuh',   'Subuh'),
    MapEntry('terbit',  'Terbit'),
    MapEntry('dhuha',   'Dhuha'),
    MapEntry('dzuhur',  'Dzuhur'),
    MapEntry('ashar',   'Ashar'),
    MapEntry('maghrib', 'Maghrib'),
    MapEntry('isya',    'Isya'),
  ];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map?;
    if (args == null) {
      // fallback sederhana
      kotaId = '1301';
      provinsi = 'DKI Jakarta';
      kota = 'KOTA JAKARTA';
      ymdPath = '2025/08/25';
      date = DateTime(2025, 8, 25);
    } else {
      kotaId   = args['kotaId'] as String;
      provinsi = args['provinsi'] as String;
      kota     = args['kota'] as String;
      ymdPath  = args['ymdPath'] as String;
      date     = DateTime.tryParse(args['dateIso'] ?? '') ?? DateTime.now();
    }
    _fetch();
    _startTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _fetch() async {
    final url = Uri.parse('https://api.myquran.com/v2/sholat/jadwal/$kotaId/$ymdPath');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      Get.snackbar('Gagal', 'HTTP ${res.statusCode}');
      return;
    }
    final body = json.decode(res.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final jad = (data['jadwal'] as Map).cast<String, dynamic>();

    setState(() {
      tanggalLabel = jad['tanggal'] as String?;
      jadwal = {
        'imsak'   : jad['imsak']   as String,
        'subuh'   : jad['subuh']   as String,
        'terbit'  : jad['terbit']  as String,
        'dhuha'   : jad['dhuha']   as String,
        'dzuhur'  : jad['dzuhur']  as String,
        'ashar'   : jad['ashar']   as String,
        'maghrib' : jad['maghrib'] as String,
        'isya'    : jad['isya']    as String,
      };
    });
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  // "HH:MM" → DateTime di tanggal terpilih
  DateTime _dt(String hhmm) {
    final parts = hhmm.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    return DateTime(date.year, date.month, date.day, h, m);
  }

  /// Cari ADZAN berikutnya (Subuh/Dzuhur/Ashar/Maghrib/Isya) untuk hari ini.
  (String label, Duration? sisa)? _nextAdzan() {
    if (jadwal == null) return null;
    final now = DateTime.now();

    // hanya hitung jika tanggal = hari ini
    if (DateTime(now.year, now.month, now.day) !=
        DateTime(date.year, date.month, date.day)) {
      return ('—', null);
    }

    const adzanSet = {'subuh', 'dzuhur', 'ashar', 'maghrib', 'isya'};
    for (final kv in _keys) {
      if (!adzanSet.contains(kv.key)) continue;
      final t = _dt(jadwal![kv.key]!);
      if (now.isBefore(t)) {
        return (kv.value, t.difference(now));
      }
    }
    return ('Selesai', null);
  }

  String _formatDur(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '$h jam ${m.toString().padLeft(2, '0')} menit';
    if (m > 0) return '$m menit ${s.toString().padLeft(2, '0')} detik';
    return '$s detik';
  }

  @override
  Widget build(BuildContext context) {
    final header = _buildHeader(context);
    final body   = _buildBody(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
        title: Text(
          kota,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/masjidil_haram.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.65)],
              ),
            ),
          ),
          Column(
            children: [
              header,
              Expanded(child: body),

              // ------ tombol ABOUT ME di bawah ------
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextButton(
                    onPressed: () => Get.toNamed(Routes.about),
                    style: TextButton.styleFrom(foregroundColor: Colors.white70),
                    child: const Text('About me'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final next = _nextAdzan(); // pakai adzan-only
    final nextText = (next == null)
        ? 'Menentukan...'
        : (next.$2 == null ? next.$1 : 'Next is ${next.$1}');
    final sisaText = (next == null)
        ? ''
        : (next.$2 == null ? '' : ' • ${_formatDur(next.$2!)} lagi');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nextText,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            sisaText,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.place, size: 18, color: Colors.white70),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$kota, $provinsi',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                tanggalLabel ?? '—',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (jadwal == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _keys.length,
      itemBuilder: (ctx, i) {
        final kv = _keys[i];
        final label = kv.value;
        final key   = kv.key;
        final time  = jadwal![key]!;
        final isNext = _isNext(key); // highlight adzan berikutnya
        return _PrayerTile(label: label, time: time, highlight: isNext);
      },
    );
  }

  bool _isNext(String key) {
    final next = _nextAdzan();
    if (next == null || next.$2 == null) return false;
    final label = next.$1;
    final map = { for (final kv in _keys) kv.value: kv.key };
    return map[label] == key;
  }
}

class _PrayerTile extends StatelessWidget {
  final String label;
  final String time;
  final bool highlight;
  const _PrayerTile({
    required this.label,
    required this.time,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    // warna highlight kuning yang enak di gelap
    const highlightColor = Color(0xFFFFD54F); // Amber 300
    final textColor = highlight ? highlightColor : Colors.white;
    final borderColor = highlight ? highlightColor.withOpacity(0.9) : Colors.white12;
    final bg = Colors.white.withOpacity(highlight ? 0.10 : 0.06);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: highlight ? 1.4 : 1),
        boxShadow: highlight
            ? [BoxShadow(color: highlightColor.withOpacity(0.25), blurRadius: 10)]
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.alarm, size: 18, color: highlight ? highlightColor : Colors.white70),
        ],
      ),
    );
  }
}
