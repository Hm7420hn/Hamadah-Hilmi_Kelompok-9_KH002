import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Profile Card',
      theme: AppTheme.lightTheme,
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Digit terakhir NIM 20240801265 adalah 5
    const int d = 5;

    // Rumus perhitungan variabel berdasarkan NIM
    final double paddingCard = 16.0 + d; // 21.0 px
    final double roundedCard = 8.0 + d; // 13.0 px
    final double tinggiTombol = 40.0 + d; // 45.0 px
    final double roundedTombol = 4.0 + d; // 9.0 px
    final double ukuranAvatar = 40.0 + (2 * d); // 50.0 px
    final double jarakNamaNim = 8.0 + d; // 13.0 px

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(roundedCard),
              ),
              child: Padding(
                padding: EdgeInsets.all(paddingCard),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: ukuranAvatar / 2,
                      child: const Icon(Icons.person, size: 30),
                    ),
                    SizedBox(height: jarakNamaNim),
                    const Text(
                      'Hamadah Hilmi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: jarakNamaNim / 2),
                    const Text(
                      '20240801265',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Teknik Informatika',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'Saya adalah mahasiswa di Kampus Esa Unggul-Bekasi, '
                      'Jurusan saya adalah Teknik Informatika',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 16.0),
                    AppButton(
                      label: 'GitHub Saya',
                      icon: Icons.code,
                      url: 'https://github.com/Hm7420hn',
                      height: tinggiTombol,
                      borderRadius: roundedTombol,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}