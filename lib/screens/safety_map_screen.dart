import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/incident_service.dart';

class SafetyMapScreen extends StatefulWidget {
  const SafetyMapScreen({super.key});

  @override
  State<SafetyMapScreen> createState() => _SafetyMapScreenState();
}

class _SafetyMapScreenState extends State<SafetyMapScreen> {

  String categoryFilter = "All";
  String severityFilter = "All";

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

  // 🧠 TRUST LEVEL LOGIC
  double getTrustLevel(Map<String, dynamic> i) {
    final severity = (i["severity"] ?? "").toString().toLowerCase();

    if (severity == "high") return 0.9;
    if (severity == "medium") return 0.7;
    return 0.5;
  }

  // 🔍 FILTER FIXED (safe comparison)
  bool matchFilters(Map<String, dynamic> i) {

    final cat = (i["category"] ?? "").toString().toLowerCase();
    final sev = (i["severity"] ?? "").toString().toLowerCase();

    final catOk = categoryFilter == "All" ||
        cat == categoryFilter.toLowerCase();

    final sevOk = severityFilter == "All" ||
        sev == severityFilter.toLowerCase();

    return catOk && sevOk;
  }

  // 📍 HOTSPOT CLICK DETAILS
  void showDetails(Map<String, dynamic> i) {

    final trust = getTrustLevel(i);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),

        title: Text(
          i["title"] ?? "Incident",
          style: const TextStyle(color: Colors.white),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Category: ${i["category"]}",
                style: const TextStyle(color: Colors.white70)),

            Text("Severity: ${i["severity"]}",
                style: const TextStyle(color: Colors.white70)),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Trust Level: ${(trust * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              i["description"] ?? "",
              style: const TextStyle(color: Colors.white60),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final filtered = incidents.where(matchFilters).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Safety Map"),
        backgroundColor: const Color(0xFF1F2937),
      ),

      body: Column(
        children: [

          // FILTER BAR
          Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF111827),
            child: Row(
              children: [

                dropdown("Category", categoryFilter,
                    ["All", "Crime", "Accident", "Violence"], (v) {
                      setState(() => categoryFilter = v!);
                    }),

                const SizedBox(width: 10),

                dropdown("Severity", severityFilter,
                    ["All", "Low", "Medium", "High"], (v) {
                      setState(() => severityFilter = v!);
                    }),
              ],
            ),
          ),

          // MAP
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(33.6844, 73.0479),
                initialZoom: 13,
              ),

              children: [

                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),

                MarkerLayer(
                  markers: List.generate(filtered.length, (index) {

                    final i = filtered[index];

                    final lat = (i["lat"] as num?)?.toDouble();
                    final lng = (i["lng"] as num?)?.toDouble();

                    if (lat == null || lng == null) return null;

                    Color color = Colors.green;

                    if (i["severity"] == "High") color = Colors.red;
                    else if (i["severity"] == "Medium") color = Colors.orange;

                    return Marker(
                      width: 50,
                      height: 50,
                      point: LatLng(lat, lng),

                      child: GestureDetector(
                        onTap: () => showDetails(i),

                        child: Icon(
                          Icons.location_on,
                          color: color,
                          size: 35,
                        ),
                      ),
                    );
                  }).whereType<Marker>().toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton(
        value: value,
        dropdownColor: const Color(0xFF1F2937),
        style: const TextStyle(color: Colors.white),
        underline: const SizedBox(),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}