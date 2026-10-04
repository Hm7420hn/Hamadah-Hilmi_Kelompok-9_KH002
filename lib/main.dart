import 'package:flutter/material.dart';
import 'profile_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Masukkan NIM Anda di sini untuk penentuan warna background
    String nim = "20230801047";

    int digitTerakhir = int.tryParse(nim.isNotEmpty ? nim[nim.length - 1] : '0') ?? 0;
    bool isGanjil = digitTerakhir % 2 != 0;

    // Ganjil: TealAccent / Toska Pastel, Genap: Amber / Oranye Pastel
    Color bgColor = isGanjil ? Colors.tealAccent.shade100 : Colors.amber.shade100;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Layout Flutter',
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        useMaterial3: true,
      ),
      home: const HomePage(nimMahasiswa: "20230801047"),
    );
  }
}

class HomePage extends StatelessWidget {
  final String nimMahasiswa;

  const HomePage({super.key, required this.nimMahasiswa});

  @override
  Widget build(BuildContext context) {
    // Perhitungan Nilai Skor Aktivitas dari 2 Digit Terakhir NIM
    // Contoh NIM: 20230801047 -> 2 digit terakhir = 47. Maka 47 + 50 = 97
    int duaDigitTerakhir = int.tryParse(
        nimMahasiswa.length >= 2 ? nimMahasiswa.substring(nimMahasiswa.length - 2) : '0'
    ) ?? 0;
    int skorDihitung = duaDigitTerakhir + 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Interaktif NIM"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ProfileCard(
          nama: "Hamadah", // Ganti dengan nama lengkap Anda
          nim: nimMahasiswa,
          hobi: "Membaca & Coding",
          skorAktivitas: skorDihitung,
        ),
      ),
    );
  }
}