import 'package:flutter/material.dart';
import '../services/incident_service.dart';

class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Incident History"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: incidents.isEmpty
          ? const Center(child: Text("No incidents reported"))
          : ListView.builder(
        itemCount: incidents.length,
        itemBuilder: (context, index) {

          final item = incidents[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    item["title"] ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text("📍 Location: ${item["location"] ?? ""}"),
                  Text("⚠ Severity: ${item["severity"] ?? ""}"),
                  Text("📂 Category: ${item["category"] ?? ""}"),
                  Text("📝 Description: ${item["description"] ?? ""}"),
                  Text("⏰ Time: ${item["time"] ?? ""}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}