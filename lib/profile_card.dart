import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String hobi;
  final int skorAktivitas;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.hobi,
    required this.skorAktivitas,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Ekstraksi Digit NIM untuk Kalkulasi Dinamis
    // Contoh digit NIM: 20230801047 -> digitTerakhir = 7, digitKe2Belakang = 4
    int digitTerakhir = int.tryParse(nim.isNotEmpty ? nim[nim.length - 1] : '0') ?? 0;
    int digitKe2Belakang = int.tryParse(nim.length >= 2 ? nim[nim.length - 2] : '0') ?? 0;

    // 2. Penerapan Formula Matematika Berdasarkan NIM
    double lebarKartu = 320.0 + (digitKe2Belakang * 5);
    double sudutMelengkung = 12.0 + (digitTerakhir * 1.5);
    double ukuranLogo = 60.0 + (digitTerakhir * 2);
    double jarakPemisah = 15.0 + digitTerakhir;

    return Container(
      width: lebarKartu,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sudutMelengkung),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu (Row)
          Row(
            children: [
              Container(
                width: ukuranLogo,
                height: ukuranLogo,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(sudutMelengkung / 2),
                ),
                child: FlutterLogo(size: ukuranLogo),
              ),
              SizedBox(width: jarakPemisah),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kartu Praktikan",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),
          const Divider(thickness: 1.5),
          const SizedBox(height: 12.0),

          // Detail Identitas (Column)
          _buildDetailRow("NIM", nim),
          const SizedBox(height: 8.0),
          _buildDetailRow("Hobi", hobi),
          const SizedBox(height: 8.0),
          _buildDetailRow("Skor Aktivitas", skorAktivitas.toString()),
        ],
      ),
    );
  }

  // Helper Widget untuk Baris Informasi
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}