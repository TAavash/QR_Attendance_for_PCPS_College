import 'package:flutter/material.dart';
import 'pages/role_selection_page.dart';
import 'pages/home_page.dart';
import 'pages/qr_scanner_page.dart';
import 'pages/generate_qr_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Attendance',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionPage(),
        '/student-home': (context) => const HomePage(),
        '/qr-scanner': (context) => const QrScannerPage(),
        '/teacher-generate': (context) => const GenerateQRPage(),
      },
    );
  }
}
