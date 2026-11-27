import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/stok_service.dart';

class InputStokScreen extends StatefulWidget {
  const InputStokScreen({super.key});

  @override
  State<InputStokScreen> createState() => _InputStokScreenState();
}

class _InputStokScreenState extends State<InputStokScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stokService = StokService();

  final _namaController = TextEditingController();
  final _tanggalMasukController = TextEditingController();
  final _tanggalKeluarController = TextEditingController();
  final _kodeBarangController = TextEditingController();
  final _jumlahStokController = TextEditingController();

  bool _isSaving = false;

  // Aturan khusus NIM Ganjil: 20240801265 -> akhiran 265 & inisial HH
  static const String _inisialWajib = 'HH';
  static const String _akhiranNimGanjil = '265';

  final RegExp _dateRegex = RegExp(
    r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$',
  );

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalMasukController.dispose();
    _tanggalKeluarController.dispose();
    _kodeBarangController.dispose();
    _jumlahStokController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final int kodeBarang = int.parse(_kodeBarangController.text.trim());
      final int jumlahStok = int.parse(_jumlahStokController.text.trim());

      await _stokService.tambahStokBarang(
        namaBarang: _namaController.text,
        tanggalMasuk: _tanggalMasukController.text,
        tanggalKeluar: _tanggalKeluarController.text,
        kodeBarang: kodeBarang,
        jumlahStok: jumlahStok,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil disimpan ke Firestore (stok_barang).'),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
      _namaController.clear();
      _tanggalMasukController.clear();
      _tanggalKeluarController.clear();
      _kodeBarangController.clear();
      _jumlahStokController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Stok Barang'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  hintText: 'Contoh: HH - Hamadah Hilmi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Nama Barang wajib diisi';
                  }
                  if (!text.toUpperCase().startsWith(_inisialWajib)) {
                    return 'Nama Barang harus diawali inisial "$_inisialWajib"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tanggalMasukController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Masuk',
                  hintText: 'Contoh: 16/10/2026',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Tanggal Masuk wajib diisi';
                  }
                  if (!_dateRegex.hasMatch(text)) {
                    return 'Gunakan format tanggal DD/MM/YYYY (misal: 16/10/2026)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tanggalKeluarController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Keluar',
                  hintText: 'Contoh: 20/10/2026',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Tanggal Keluar wajib diisi';
                  }
                  if (!_dateRegex.hasMatch(text)) {
                    return 'Gunakan format tanggal DD/MM/YYYY (misal: 20/10/2026)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kodeBarangController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Kode Barang',
                  hintText: 'Minimal 6 digit, akhiran 265 (misal: 100265)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Kode Barang wajib diisi';
                  }
                  if (text.length < 6) {
                    return 'Kode Barang minimal 6 digit angka';
                  }
                  if (!text.endsWith(_akhiranNimGanjil)) {
                    return 'Kode Barang harus diakhiri 3 digit NIM Ganjil ($_akhiranNimGanjil)';
                  }
                  if (int.tryParse(text) == null) {
                    return 'Kode Barang harus berupa angka valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jumlahStokController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Jumlah Stok',
                  hintText: 'Bilangan bulat >= 0 (misal: 30)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Jumlah Stok wajib diisi';
                  }
                  final parsed = int.tryParse(text);
                  if (parsed == null || parsed < 0) {
                    return 'Jumlah Stok harus bilangan bulat >= 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _simpanData,
                  child: _isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan Barang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}