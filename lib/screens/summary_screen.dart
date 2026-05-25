import 'package:flutter/material.dart';
import '../services/alert_service.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final summary = AlertService.getDailySummary();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "DAILY SAFETY SUMMARY",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Crime: ${summary["Crime"]}",
                style: const TextStyle(color: Colors.white)),

            Text("Accident: ${summary["Accident"]}",
                style: const TextStyle(color: Colors.white)),

            Text("Violence: ${summary["Violence"]}",
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}