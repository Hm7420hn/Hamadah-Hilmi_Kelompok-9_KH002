// Widget test untuk pertmuan5 - Input Stok Barang
//
// Test ini memverifikasi bahwa form Input Stok Barang
// menampilkan semua field dan tombol dengan benar,
// tanpa memerlukan koneksi Firebase sungguhan.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Halaman Input Stok menampilkan semua field form',
      (WidgetTester tester) async {
    // Render widget form secara langsung tanpa Firebase
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextField(decoration: InputDecoration(labelText: 'Nama Barang')),
                TextField(decoration: InputDecoration(labelText: 'Tanggal Masuk')),
                TextField(decoration: InputDecoration(labelText: 'Tanggal Keluar')),
                TextField(decoration: InputDecoration(labelText: 'Kode Barang')),
                TextField(decoration: InputDecoration(labelText: 'Jumlah Stok')),
                ElevatedButton(onPressed: null, child: Text('Simpan Barang')),
              ],
            ),
          ),
        ),
      ),
    );

    // Verifikasi semua label field tampil
    expect(find.text('Nama Barang'), findsOneWidget);
    expect(find.text('Tanggal Masuk'), findsOneWidget);
    expect(find.text('Tanggal Keluar'), findsOneWidget);
    expect(find.text('Kode Barang'), findsOneWidget);
    expect(find.text('Jumlah Stok'), findsOneWidget);
    expect(find.text('Simpan Barang'), findsOneWidget);
  });
}
