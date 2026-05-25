import 'package:hive/hive.dart';

class IncidentService {

  static final Box box = Hive.box('incidentsBox');

  // ➕ ADD INCIDENT
  static void addIncident(Map<String, dynamic> incident) {
    box.add(incident);
  }

  // 📥 GET ALL
  static List<Map<String, dynamic>> getIncidents() {
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // ❌ DELETE
  static void deleteIncident(int index) {
    box.deleteAt(index);
  }

  // ✏ UPDATE
  static void updateIncident(int index, Map<String, dynamic> data) {
    box.putAt(index, data);
  }

  // 🧹 CLEAR ALL
  static void clearAll() {
    box.clear();
  }
}