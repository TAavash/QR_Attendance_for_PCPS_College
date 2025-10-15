import 'package:flutter/material.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text(
          'QR Scanner Page Placeholder',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
