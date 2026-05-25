import 'package:hive_flutter/hive_flutter.dart';

class IncidentService {

  static final Box box = Hive.box('incidentsBox');

  // ➕ ADD INCIDENT
  static void addIncident(Map<String, dynamic> incident) {
    box.add(_normalize(incident));
  }

  // 📥 GET INCIDENTS
  static List<Map<String, dynamic>> getIncidents() {
    return box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // ❌ DELETE INCIDENT
  static void deleteIncident(int index) {
    box.deleteAt(index);
  }

  // 🧹 CLEAR ALL (for debugging / reset)
  static void clearAll() {
    box.clear();
  }

  // 🔧 NORMALIZATION (VERY IMPORTANT FOR YOUR BUG FIX)
  static Map<String, dynamic> _normalize(Map<String, dynamic> i) {
    return {
      "title": (i["title"] ?? "").toString(),
      "description": (i["description"] ?? "").toString(),
      "category": (i["category"] ?? "Crime").toString().trim(),
      "severity": (i["severity"] ?? "Low").toString().trim(),
      "lat": (i["lat"] as num?)?.toDouble(),
      "lng": (i["lng"] as num?)?.toDouble(),
      "time": i["time"] ?? DateTime.now().toString(),
      "image": i["image"],
    };
  }
}