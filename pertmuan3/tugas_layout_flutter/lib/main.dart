import 'package:flutter/material.dart';

import 'profile_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String nim = "20240801265"; // Ganti dengan NIM Anda

    int digitTerakhir =
        int.tryParse(nim.isNotEmpty ? nim[nim.length - 1] : '0') ?? 0;
    bool isGanjil = digitTerakhir % 2 != 0;

    // Warna background berdasarkan NIM (Ganjil: Toska, Genap: Amber)
    Color bgColor = isGanjil
        ? Colors.tealAccent.shade100
        : Colors.amber.shade100;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Layout Flutter',
      theme: ThemeData(scaffoldBackgroundColor: bgColor, useMaterial3: true),
      home: const HomePage(nimMahasiswa: nim),
    );
  }
}

class HomePage extends StatelessWidget {
  final String nimMahasiswa;

  const HomePage({super.key, required this.nimMahasiswa});

  @override
  Widget build(BuildContext context) {
    // Perhitungan skor aktivitas: 2 digit terakhir NIM + 50
    int duaDigitTerakhir =
        int.tryParse(
          nimMahasiswa.length >= 2
              ? nimMahasiswa.substring(nimMahasiswa.length - 2)
              : '0',
        ) ??
        0;
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
          nama: "Hamadah",
          nim: nimMahasiswa,
          hobi: "Membaca & Coding",
          skorAktivitas: skorDihitung,
        ),
      ),
    );
  }
}
