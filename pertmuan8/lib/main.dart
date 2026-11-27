import 'package:flutter/material.dart';
import 'package:pemmob_tugas8/models/admin.dart';
import 'package:pemmob_tugas8/models/user.dart';
import 'package:pemmob_tugas8/services/admin_service.dart';
import 'package:pemmob_tugas8/services/api_service.dart';

void main() {
  runApp(const Pertemuan8App());
}

class Pertemuan8App extends StatelessWidget {
  const Pertemuan8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pertemuan 8 - CRUD User & Admin',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<User> _users = [];
  List<Admin> _admins = [];
  bool _isLoadingUsers = true;
  bool _isLoadingAdmins = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _loadAllData() async {
    await Future.wait([_fetchUsers(), _fetchAdmins()]);
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoadingUsers = true);
    try {
      final data = await ApiService.getUsers();
      if (!mounted) return;
      setState(() => _users = data);
    } catch (e) {
      _showSnack('Gagal memuat User: $e');
    } finally {
      if (mounted) setState(() => _isLoadingUsers = false);
    }
  }

  Future<void> _fetchAdmins() async {
    setState(() => _isLoadingAdmins = true);
    try {
      final data = await AdminService.getAdmins();
      if (!mounted) return;
      setState(() => _admins = data);
    } catch (e) {
      _showSnack('Gagal memuat Admin: $e');
    } finally {
      if (mounted) setState(() => _isLoadingAdmins = false);
    }
  }

  Future<void> _openCreateUserDialog() async {
    final nameCtrl = TextEditingController(text: 'Hamadah Hilmi');
    final emailCtrl = TextEditingController(text: 'hamadah.hilmi@kampus.ac.id');
    final cityCtrl = TextEditingController(text: 'Bekasi');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('POST User Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: cityCtrl,
              decoration: const InputDecoration(labelText: 'City'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final created = await ApiService.createUser(
          name: nameCtrl.text,
          email: emailCtrl.text,
          city: cityCtrl.text,
        );
        await _fetchUsers();
        _showSnack('POST berhasil: ${created.name} (ID: ${created.id})');
      } catch (e) {
        _showSnack('Gagal POST User: $e');
      }
    }
  }

  Future<void> _openPutDialog(User user) async {
    final nameCtrl = TextEditingController(text: user.name);
    final emailCtrl = TextEditingController(text: user.email);
    final cityCtrl = TextEditingController(text: user.city);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('PUT User #${user.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama Baru'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email Baru'),
            ),
            TextField(
              controller: cityCtrl,
              decoration: const InputDecoration(labelText: 'City'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Update (PUT)'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final updated = await ApiService.updateUserPut(
          id: user.id,
          name: nameCtrl.text,
          email: emailCtrl.text,
          city: cityCtrl.text,
        );
        await _fetchUsers();
        _showSnack('PUT berhasil: ${updated.name} (ID: ${updated.id})');
      } catch (e) {
        _showSnack('Gagal PUT User: $e');
      }
    }
  }

  Future<void> _handlePatchUser(User user) async {
    try {
      final patched = await ApiService.updateUserPatch(user.id);
      await _fetchUsers();
      _showSnack('PATCH berhasil: ${patched.name}');
    } catch (e) {
      _showSnack('Gagal PATCH User: $e');
    }
  }

  Future<void> _handleDeleteUser(User user) async {
    try {
      await ApiService.deleteUser(user.id);
      await _fetchUsers();
      _showSnack('DELETE User ID ${user.id} berhasil');
    } catch (e) {
      _showSnack('Gagal DELETE User: $e');
    }
  }

  Future<void> _handleDeleteAdmin(Admin admin) async {
    try {
      await AdminService.deleteAdmin(admin.id);
      await _fetchAdmins();
      _showSnack('DELETE Admin ID ${admin.id} berhasil');
    } catch (e) {
      _showSnack('Gagal DELETE Admin: $e');
    }
  }

  Future<void> _openUserDetail(int id) async {
    try {
      final detail = await ApiService.getUser(id);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(
            title: 'Detail User #${detail.id}',
            rows: [
              ('ID', '${detail.id}'),
              ('Nama', detail.name),
              ('Email', detail.email),
              ('City', detail.city),
            ],
          ),
        ),
      );
    } catch (e) {
      _showSnack('Gagal membuka detail User: $e');
    }
  }

  Future<void> _openAdminDetail(int id) async {
    try {
      final detail = await AdminService.getAdmin(id);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(
            title: 'Detail Admin #${detail.id}',
            rows: [
              ('ID', '${detail.id}'),
              ('Nama', detail.name),
              ('Email', detail.email),
              ('Department', detail.department),
            ],
          ),
        ),
      );
    } catch (e) {
      _showSnack('Gagal membuka detail Admin: $e');
    }
  }

  Widget _buildUserTab() {
    if (_isLoadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _fetchUsers,
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final u = _users[index];
          return ListTile(
            title: Text('${u.name} (ID: ${u.id})'),
            subtitle: Text('${u.email} • ${u.city}'),
            onTap: () => _openUserDetail(u.id),
            trailing: PopupMenuButton<String>(
              onSelected: (action) {
                if (action == 'put') _openPutDialog(u);
                if (action == 'patch') _handlePatchUser(u);
                if (action == 'delete') _handleDeleteUser(u);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'put', child: Text('PUT (Edit Nama & Email)')),
                PopupMenuItem(value: 'patch', child: Text('PATCH (+ Flutter Developer)')),
                PopupMenuItem(value: 'delete', child: Text('DELETE')),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminTab() {
    if (_isLoadingAdmins) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _fetchAdmins,
      child: ListView.builder(
        itemCount: _admins.length,
        itemBuilder: (context, index) {
          final a = _admins[index];
          return ListTile(
            title: Text('${a.name} (ID: ${a.id})'),
            subtitle: Text('${a.email} • ${a.department}'),
            onTap: () => _openAdminDetail(a.id),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _handleDeleteAdmin(a),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'N=${ApiService.nimN} | User=${ApiService.nimUserId} | Admin=${AdminService.nimAdminId}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildUserTab() : _buildAdminTab(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _openCreateUserDialog,
              icon: const Icon(Icons.add),
              label: const Text('POST User'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'User'),
          NavigationDestination(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;

  const DetailPage({
    super.key,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rows
                  .map(
                    (row) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text('${row.$1}: ${row.$2}'),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}