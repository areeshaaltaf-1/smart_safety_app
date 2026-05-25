import 'package:flutter/material.dart';

import '../services/alert_service.dart';
import '../services/incident_service.dart';

import 'report_incident_screen.dart';
import 'safety_map_screen.dart';
import 'incidents_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  List<Map<String, dynamic>> incidents = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    incidents = IncidentService.getIncidents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final recent = AlertService.getRecentIncidents();
    final summary = AlertService.getDailySummary();

    return Scaffold(

      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: RefreshIndicator(

        onRefresh: () async {
          loadData();
        },

        child: SingleChildScrollView(

          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // 🚨 ALERTS
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "🚨 Community Alerts",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (recent.isEmpty)
                      const Text(
                        "No recent incidents",
                        style: TextStyle(color: Colors.white70),
                      )
                    else
                      ...recent.take(5).map(
                            (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            "• ${i["title"]} (${i["severity"]})",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 📊 SUMMARY
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "📊 Daily Safety Summary",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Crime: ${summary["Crime"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),

                    Text(
                      "Accident: ${summary["Accident"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),

                    Text(
                      "Violence: ${summary["Violence"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 📍 REPORT INCIDENT
              dashboardCard(
                title: "Report Incident",
                icon: Icons.report,
                color: Colors.redAccent,
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportIncidentScreen(),
                    ),
                  ).then((_) => loadData());
                },
              ),

              const SizedBox(height: 15),

              // 🗺 SAFETY MAP
              dashboardCard(
                title: "Safety Map",
                icon: Icons.map,
                color: Colors.orange,
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SafetyMapScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              // 📜 INCIDENT HISTORY
              dashboardCard(
                title: "Incident History",
                icon: Icons.history,
                color: Colors.teal,
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IncidentsScreen(),
                    ),
                  ).then((_) => loadData());
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🎨 DASHBOARD CARD
  Widget dashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
        ),

        child: Row(
          children: [

            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}