// =============================================================================
// Form Profil Mahasiswa Interaktif
// Praktikum Mandiri 1 — Materi 4: State, Events & User Interaction
// Mata Kuliah : Pemrograman Aplikasi Bergerak
// Mahasiswa   : FAZA RIZAL ANNAFI
// NIM         : 2411100
// Kelas       : IFB5A
// Universitas : Universitas Mulia
//
// Dikerjakan dengan Flutter/Dart sesuai arahan dosen
// (adaptasi dari panduan Jetpack Compose).
//
// Padanan konsep Compose → Flutter:
//   remember { mutableStateOf("") }  →  field di State + setState()
//   onValueChange                    →  TextField.onChanged
//   onClick                          →  ElevatedButton.onPressed
//   recomposition                    →  rebuild widget setelah setState()
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ProfilInteraktifApp());
}

class ProfilInteraktifApp extends StatelessWidget {
  const ProfilInteraktifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Profil Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const FormProfilPage(),
    );
  }
}

/// Layar utama form profil.
/// StatefulWidget = widget yang punya STATE (data yang bisa berubah).
class FormProfilPage extends StatefulWidget {
  const FormProfilPage({super.key});

  @override
  State<FormProfilPage> createState() => _FormProfilPageState();
}

class _FormProfilPageState extends State<FormProfilPage> {
  // ---------------------------------------------------------------------------
  // STATE  (padanan: remember { mutableStateOf("") } di Jetpack Compose)
  // Data yang diingat layar. Setiap kali berubah lewat setState(),
  // Flutter membangun ulang tampilan (padanan recomposition).
  // ---------------------------------------------------------------------------
  String nama = '';
  String nim = '';
  String prodi = '';
  bool sudahSimpan = false;

  /// Validasi: ketiga kolom wajib diisi dan bukan spasi kosong.
  /// Tombol Simpan hanya aktif bila nilai ini true.
  bool get valid =>
      nama.trim().isNotEmpty &&
      nim.trim().isNotEmpty &&
      prodi.trim().isNotEmpty;

  // ---------------------------------------------------------------------------
  // EVENT onValueChange  (padanan: onValueChange di Compose)
  // Dipanggil setiap kali pengguna mengetik. Kita:
  //  1) simpan teks baru ke state
  //  2) sembunyikan kartu hasil sampai tombol Simpan ditekan lagi
  // ---------------------------------------------------------------------------
  void _ubahNama(String value) {
    setState(() {
      nama = value;
      sudahSimpan = false;
    });
  }

  void _ubahNim(String value) {
    setState(() {
      nim = value;
      sudahSimpan = false;
    });
  }

  void _ubahProdi(String value) {
    setState(() {
      prodi = value;
      sudahSimpan = false;
    });
  }

  // ---------------------------------------------------------------------------
  // EVENT onClick  (padanan: onClick / onPressed)
  // Hanya bisa ditekan jika valid == true (properti enabled pada tombol).
  // ---------------------------------------------------------------------------
  void _simpanProfil() {
    setState(() {
      sudahSimpan = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Form Profil Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _bannerInfo(scheme),
              const SizedBox(height: 18),
              const Text(
                'Isi data diri',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ketiga kolom wajib diisi. Tombol Simpan aktif otomatis setelah lengkap.',
                style: TextStyle(fontSize: 13, color: Color(0xFF5A6A80)),
              ),
              const SizedBox(height: 14),

              // INPUT Nama
              TextField(
                onChanged: _ubahNama, // EVENT
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Contoh: FAZA RIZAL ANNAFI',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),

              // INPUT NIM
              TextField(
                onChanged: _ubahNim, // EVENT
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  hintText: 'Contoh: 2411100',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // INPUT Program Studi
              TextField(
                onChanged: _ubahProdi, // EVENT
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  hintText: 'Contoh: Informatika',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // Pesan bantuan jika belum valid
              if (!valid)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4E5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFCC80)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFFEF6C00),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Lengkapi ketiga kolom untuk menyimpan.',
                          style: TextStyle(
                            color: Color(0xFFBF360C),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // TOMBOL SIMPAN — enabled mengikuti state valid
              FilledButton.icon(
                onPressed: valid ? _simpanProfil : null, // EVENT onClick
                icon: const Icon(Icons.save_outlined),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Simpan Profil',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // KARTU HASIL — hanya tampil setelah tombol ditekan
              if (sudahSimpan) _kartuHasil(scheme),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'FAZA RIZAL ANNAFI  •  2411100  •  IFB5A',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5A6A80),
                  letterSpacing: 0.2,
                ),
              ),
              const Text(
                'Universitas Mulia  •  Praktikum Mandiri 1',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Color(0xFF8A97A8)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerInfo(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.account_circle,
              size: 36,
              color: Color(0xFF0D47A1),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Universitas Mulia',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Praktikum Mandiri 1  •  Materi 4',
                  style: TextStyle(color: Color(0xFFBBDEFB), fontSize: 12),
                ),
                Text(
                  'State, Events & User Interaction',
                  style: TextStyle(color: Color(0xFFE3F2FD), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuHasil(ColorScheme scheme) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFC8E6C9)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
                SizedBox(width: 8),
                Text(
                  'Profil Tersimpan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _barisHasil(Icons.person, 'Nama', nama.trim()),
            _barisHasil(Icons.badge, 'NIM', nim.trim()),
            _barisHasil(Icons.school, 'Program Studi', prodi.trim()),
          ],
        ),
      ),
    );
  }

  Widget _barisHasil(IconData ikon, String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 20, color: const Color(0xFF1565C0)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF78909C),
                  ),
                ),
                Text(
                  nilai,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
