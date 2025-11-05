import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:http/http.dart' as http;

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _scanned = false;
  String _resultMessage = '';
  bool _isLoading = false;

  // Replace this with actual logged-in student ID later
  final String _studentId = "1";

  Future<void> _validateQR(String qrData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final decoded = jsonDecode(qrData);

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/validate-qr/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'encrypted': decoded['encrypted'],
          'hash': decoded['hash'],
          'student_id': _studentId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _resultMessage =
              "✅ ${data['message']}\nSubject: ${data['subject'] ?? ''}";
        });
      } else {
        setState(() {
          _resultMessage = "❌ Failed: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _resultMessage = "⚠️ Invalid QR or Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Attendance QR"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  if (!_scanned) {
                    setState(() {
                      _scanned = true;
                    });
                    controller.pauseCamera();
                    _validateQR(scanData.code!);
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      _resultMessage.isEmpty
                          ? 'Scan a QR code to mark attendance'
                          : _resultMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.refresh),
        onPressed: () {
          controller?.resumeCamera();
          setState(() {
            _scanned = false;
            _resultMessage = '';
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
