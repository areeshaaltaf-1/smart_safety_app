import 'package:flutter/material.dart';

import '../services/alert_service.dart';
import '../services/incident_service.dart';
import '../services/profile_service.dart';

import 'report_incident_screen.dart';
import 'safety_map_screen.dart';
import 'incidents_screen.dart';
import 'sos_screen.dart';
import 'profile_screen.dart';

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

    final isVerified = ProfileService.isVerifiedUser();

    return Scaffold(

      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF1E293B),
        actions: [

          IconButton(
            icon: Icon(
              Icons.verified,
              color: isVerified ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              ).then((_) => setState(() {}));
            },
          )

        ],
      ),

      body: RefreshIndicator(

        onRefresh: () async => loadData(),

        child: SingleChildScrollView(

          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // 🔴 PROFILE STATUS CARD
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: isVerified
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isVerified
                      ? "✅ Verified User"
                      : "⚠ Unverified User - Some features limited",
                  style: TextStyle(
                    color: isVerified ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 🚨 ALERTS
              sectionCard(
                title: "🚨 Community Alerts",
                titleColor: Colors.redAccent,
                child: recent.isEmpty
                    ? const Text(
                  "No recent incidents",
                  style: TextStyle(color: Colors.white70),
                )
                    : Column(
                  children: recent.take(5).map((i) {
                    return Text(
                      "• ${i["title"]} (${i["severity"]})",
                      style: const TextStyle(color: Colors.white70),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 15),

              // 📊 SUMMARY
              sectionCard(
                title: "📊 Daily Safety Summary",
                titleColor: Colors.tealAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Crime: ${summary["Crime"]}",
                        style: const TextStyle(color: Colors.white70)),
                    Text("Accident: ${summary["Accident"]}",
                        style: const TextStyle(color: Colors.white70)),
                    Text("Violence: ${summary["Violence"]}",
                        style: const TextStyle(color: Colors.white70)),
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

              // 🚨 SOS EMERGENCY
              dashboardCard(
                title: "SOS Emergency",
                icon: Icons.warning,
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SOSScreen(),
                    ),
                  );
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

              // 📜 HISTORY
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

              const SizedBox(height: 15),

              // 👤 PROFILE (NEW)
              dashboardCard(
                title: "User Profile",
                icon: Icons.person,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionCard({
    required String title,
    required Widget child,
    required Color titleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

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
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }
}