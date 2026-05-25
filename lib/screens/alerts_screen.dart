import 'package:flutter/material.dart';
import '../services/alert_service.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final recent = AlertService.getRecentIncidents();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "COMMUNITY ALERTS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: recent.isEmpty
            ? const Text("No alerts",
            style: TextStyle(color: Colors.white70))
            : ListView.builder(
          itemCount: recent.length,
          itemBuilder: (context, index) {
            final i = recent[index];

            return Card(
              color: const Color(0xFF1F2937),
              child: ListTile(
                title: Text(i["title"],
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(i["severity"],
                    style: const TextStyle(color: Colors.white70)),
              ),
            );
          },
        ),
      ),
    );
  }
}