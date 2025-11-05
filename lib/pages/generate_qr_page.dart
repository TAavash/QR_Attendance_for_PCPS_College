import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({super.key});

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  final TextEditingController _teacherIdController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  bool _isLoading = false;
  String? _qrBase64;
  String? _message;

  Future<void> _generateQR() async {
    setState(() {
      _isLoading = true;
      _qrBase64 = null;
      _message = null;
    });

    final url = Uri.parse('http://127.0.0.1:8000/api/generate-qr/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'teacher_id': _teacherIdController.text,
          'subject': _subjectController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _qrBase64 = data['qr_image_base64'];
          _message = data['message'];
        });
      } else {
        setState(() {
          _message = "Failed: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error: $e";
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
        title: const Text("Generate Attendance QR"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _teacherIdController,
              decoration: const InputDecoration(
                labelText: "Teacher ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: "Subject Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generateQR,
              icon: const Icon(Icons.qr_code_2),
              label: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Generate QR Code"),
            ),
            const SizedBox(height: 24),
            if (_qrBase64 != null)
              Column(
                children: [
                  Text(_message ?? "QR Generated Successfully!"),
                  const SizedBox(height: 12),
                  Image.memory(base64Decode(_qrBase64!)),
                ],
              ),
            if (_message != null && _qrBase64 == null)
              Text(
                _message!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
