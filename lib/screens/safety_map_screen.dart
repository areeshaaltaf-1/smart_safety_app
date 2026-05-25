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
  String searchQuery = "";
  DateTime? selectedDate;

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

  // ---------- TRUST LEVEL ----------
  double getTrustLevel(Map<String, dynamic> i) {
    final sev = (i["severity"] ?? "").toString().toLowerCase();

    if (sev == "high") return 0.9;
    if (sev == "medium") return 0.7;
    return 0.5;
  }

  // ---------- FILTER LOGIC ----------
  bool matchFilters(Map<String, dynamic> i) {
    final category = (i["category"] ?? "").toString().toLowerCase();
    final severity = (i["severity"] ?? "").toString().toLowerCase();
    final title = (i["title"] ?? "").toString().toLowerCase();

    DateTime? time;
    try {
      time = DateTime.parse(i["time"].toString());
    } catch (_) {}

    final categoryOk =
        categoryFilter == "All" ||
            category == categoryFilter.toLowerCase();

    final severityOk =
        severityFilter == "All" ||
            severity == severityFilter.toLowerCase();

    final searchOk =
        searchQuery.isEmpty || title.contains(searchQuery.toLowerCase());

    final dateOk =
        selectedDate == null ||
            (time != null &&
                time.year == selectedDate!.year &&
                time.month == selectedDate!.month &&
                time.day == selectedDate!.day);

    return categoryOk && severityOk && searchOk && dateOk;
  }

  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void clearFilters() {
    setState(() {
      categoryFilter = "All";
      severityFilter = "All";
      searchQuery = "";
      selectedDate = null;
    });
  }

  void showDetails(Map<String, dynamic> i) {
    final trust = getTrustLevel(i);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: Text(i["title"] ?? "",
            style: const TextStyle(color: Colors.white)),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${i["category"]}",
                style: const TextStyle(color: Colors.white70)),
            Text("Severity: ${i["severity"]}",
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text(
              "Trust Level ${(trust * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(i["description"] ?? "",
                style: const TextStyle(color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = incidents.where(matchFilters).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1F2937),
        title: const Text(
          "SAFETY MAP",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: clearFilters,
          )
        ],
      ),

      body: Column(
        children: [

          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: "Search incidents...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF111827),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 🎛 FILTERS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [

                filterBox(
                  "Category",
                  categoryFilter,
                  ["All", "Crime", "Accident", "Violence"],
                      (v) => setState(() => categoryFilter = v!),
                ),

                filterBox(
                  "Severity",
                  severityFilter,
                  ["All", "Low", "Medium", "High"],
                      (v) => setState(() => severityFilter = v!),
                ),

                TextButton(
                  onPressed: pickDate,
                  child: const Text("Pick Date",
                      style: TextStyle(color: Colors.tealAccent)),
                ),

                if (selectedDate != null)
                  TextButton(
                    onPressed: () => setState(() => selectedDate = null),
                    child: const Text("Clear Date",
                        style: TextStyle(color: Colors.redAccent)),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "Results: ${filtered.length}",
            style: const TextStyle(color: Colors.white70),
          ),

          // 🗺 MAP
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(33.6844, 73.0479),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),

                MarkerLayer(
                  markers: filtered.map((i) {
                    final lat = (i["lat"] as num?)?.toDouble();
                    final lng = (i["lng"] as num?)?.toDouble();

                    if (lat == null || lng == null) {
                      return null;
                    }

                    Color color = Colors.green;
                    if (i["severity"] == "High") color = Colors.red;
                    if (i["severity"] == "Medium") color = Colors.orange;

                    return Marker(
                      point: LatLng(lat, lng),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => showDetails(i),
                        child: Icon(Icons.location_on,
                            color: color, size: 35),
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

  Widget filterBox(String label, String value,
      List<String> items, Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.all(5),
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
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}