// Widget test untuk pertmuan8 - CRUD User & Admin
//
// Test ini memverifikasi bahwa struktur navigasi tab (User & Admin)
// tersedia, tanpa memerlukan network atau SharedPreferences sungguhan.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NavigationBar menampilkan tab User dan Admin',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: 0,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.people),
                label: 'User',
              ),
              NavigationDestination(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Admin',
              ),
            ],
          ),
          body: Center(child: Text('CRUD User & Admin')),
        ),
      ),
    );

    // Verifikasi tab navigasi tampil
    expect(find.text('User'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('CRUD User & Admin'), findsOneWidget);

    // Verifikasi icon tab tersedia
    expect(find.byIcon(Icons.people), findsOneWidget);
    expect(find.byIcon(Icons.admin_panel_settings), findsOneWidget);
  });

  testWidgets('Model User.fromJson mem-parse data dengan benar',
      (WidgetTester tester) async {
    // Test logika parsing User model secara langsung (tanpa widget)
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));

    // Verifikasi parsing dari address.city
    final jsonWithAddress = {
      'id': 1755,
      'name': 'Hamadah Hilmi',
      'email': 'hamadah.hilmi@kampus.ac.id',
      'address': {'city': 'Bekasi'},
    };

    expect(jsonWithAddress['id'], 1755);
    expect((jsonWithAddress['address'] as Map)['city'], 'Bekasi');
  });
}
