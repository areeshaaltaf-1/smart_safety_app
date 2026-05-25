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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incident History"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: ListView.builder(
        itemCount: incidents.length,
        itemBuilder: (context, index) {

          final incident = incidents[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(

              title: Text(incident["title"] ?? ""),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Location: ${incident["location"] ?? "Auto GPS"}"),
                  Text("Category: ${incident["category"] ?? ""}"),
                  Text("Severity: ${incident["severity"] ?? ""}"),

                ],
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      IncidentService.deleteIncident(index);
                      loadData();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}