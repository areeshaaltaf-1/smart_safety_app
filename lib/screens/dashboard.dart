import 'package:flutter/material.dart';

import '../services/alert_service.dart';
import '../services/incident_service.dart';

import 'report_incident_screen.dart';
import 'safety_map_screen.dart';
import 'incidents_screen.dart';
import 'sos_screen.dart';
import 'profile_screen.dart';
import 'alerts_screen.dart';
import 'summary_screen.dart';

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
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "DASHBOARD",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          )
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async => loadData(),

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),

          child: Column(
            children: [

              // ===================== 4 SMALL CARDS =====================
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                crossAxisSpacing: 8,
                mainAxisSpacing: 8,

                // 🔥 KEY FIX (SMALLER HEIGHT)
                childAspectRatio: 2.6,

                children: [

                  menuCard(
                    title: "Incident Report",
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

                  menuCard(
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

                  menuCard(
                    title: "SOS",
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

                  menuCard(
                    title: "Incident History",
                    icon: Icons.history,
                    color: Colors.teal,
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

              const SizedBox(height: 10),

              // ===================== COMMUNITY ALERTS =====================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AlertsScreen(),
                    ),
                  );
                },
                child: clickableSection(
                  title: "Community Alerts",
                  color: Colors.redAccent,
                  child: recent.isEmpty
                      ? const Text(
                    "No recent incidents",
                    style: TextStyle(color: Colors.white70),
                  )
                      : Column(
                    children: recent.take(3).map((i) {
                      return Text(
                        "• ${i["title"]}",
                        style: const TextStyle(color: Colors.white70),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ===================== DAILY SUMMARY =====================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SummaryScreen(),
                    ),
                  );
                },
                child: clickableSection(
                  title: "Daily Safety Summary",
                  color: Colors.tealAccent,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== SMALL MENU CARD (FIXED SIZE) =====================
  Widget menuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),

        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== CLICKABLE SECTION =====================
  Widget clickableSection({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),

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
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          child,
        ],
      ),
    );
  }
}