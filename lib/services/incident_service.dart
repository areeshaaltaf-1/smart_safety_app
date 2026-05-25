import 'package:hive_flutter/hive_flutter.dart';

class IncidentService {
  static final Box box = Hive.box('incidentsBox');

  // ADD INCIDENT
  static void addIncident(Map<String, dynamic> incident) {
    box.add(incident);
  }

  // GET ALL INCIDENTS
  static List<Map<String, dynamic>> getIncidents() {
    return box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // DELETE INCIDENT
  static void deleteIncident(int index) {
    box.deleteAt(index);
  }

  // CLEAR ALL (optional)
  static void clearAll() {
    box.clear();
  }
}