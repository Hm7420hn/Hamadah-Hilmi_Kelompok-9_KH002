import 'package:cloud_firestore/cloud_firestore.dart';

class StokService {
  final CollectionReference<Map<String, dynamic>> _stokCollection =
      FirebaseFirestore.instance.collection('stok_barang');

  Future<void> tambahStokBarang({
    required String namaBarang,
    required String tanggalMasuk,
    required String tanggalKeluar,
    required int kodeBarang,
    required int jumlahStok,
  }) async {
    await _stokCollection.add({
      'nama_barang': namaBarang.trim(),
      'tanggal_masuk': tanggalMasuk.trim(),
      'tanggal_keluar': tanggalKeluar.trim(),
      'kode_barang': kodeBarang,
      'jumlah_stok': jumlahStok,
      'waktu': FieldValue.serverTimestamp(),
    });
  }
}
