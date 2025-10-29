import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatefulWidget {
  @override
  _GenerateQRPageState createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  String? qrData;
  bool isLoading = false;

  Future<void> generateQR() async {
    setState(() => isLoading = true);

    final url = Uri.parse('http://127.0.0.1:8000/api/generate-qr/');
    final response = await http.post(url, body: {
      'teacher_id': '1',
      'subject': 'Web Technology',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        qrData = jsonEncode(data['payload']);
        isLoading = false;
      });
    } else {
      print('Error: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate QR')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : qrData == null
                ? ElevatedButton(
                    onPressed: generateQR,
                    child: Text('Generate QR'),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImageView(
                        data: qrData!,
                        version: QrVersions.auto,
                        size: 250,
                      ),
                      SizedBox(height: 20),
                      Text('QR generated successfully!')
                    ],
                  ),
      ),
    );
  }
}
