import 'package:flutter/material.dart';
import '../widgets/class_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = "Aavash Tamang";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/images/pcps_logo.png',
          height: 40,
        ),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black87),
          SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: Colors.black26,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, $userName",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Today's Classes",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Class cards
              const ClassCard(
                code: "CIS046-3",
                title: "Software For ...",
                teacher: "Krishna Aryal",
                location: "Himalaya, Sagar",
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              const ClassCard(
                code: "CIS046-3",
                title: "Software For ...",
                teacher: "Krishna Aryal",
                location: "Himalaya, Sagar",
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const ClassCard(
                code: "CIS046-3",
                title: "Software For ...",
                teacher: "Krishna Aryal",
                location: "Himalaya, Sagar",
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pushNamed(context, '/qr-scanner');
        },
        child: const Icon(Icons.qr_code_scanner, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
