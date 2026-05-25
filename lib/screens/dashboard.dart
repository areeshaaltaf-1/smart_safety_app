import 'package:flutter/material.dart';
import 'report_incident_screen.dart';
import 'safety_map_screen.dart';
import 'incidents_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 15),

        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),

        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: Container(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            const Text(
              "Welcome to Smart Safety App",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            buildCard(
              title: "Report Incident",
              icon: Icons.report,
              color: const Color(0xFF1E293B),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportIncidentScreen(),
                  ),
                );
              },
            ),

            buildCard(
              title: "Safety Map",
              icon: Icons.map,
              color: const Color(0xFF0F766E),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SafetyMapScreen(),
                  ),
                );
              },
            ),

            buildCard(
              title: "Incident History",
              icon: Icons.list_alt,
              color: const Color(0xFF334155),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const IncidentsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}