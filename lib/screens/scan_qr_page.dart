import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanQRPage extends StatefulWidget {
  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? message;

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      await validateQR(scanData.code!);
    });
  }

  Future<void> validateQR(String data) async {
    try {
      final payload = jsonDecode(data);
      final url = Uri.parse('http://127.0.0.1:8000/api/validate-qr/');
      final response = await http.post(url, body: {
        'encrypted': jsonEncode(payload['encrypted']),
        'hash': payload['hash'],
        'student_id': '1', // change dynamically later
      });

      final result = jsonDecode(response.body);
      setState(() => message = result['message'] ?? result['error']);
    } catch (e) {
      setState(() => message = 'Invalid QR format');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(key: qrKey, onQRViewCreated: onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(message ?? 'Scan a QR Code'),
            ),
          ),
        ],
      ),
    );
  }
}
