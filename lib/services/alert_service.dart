import 'package:hive/hive.dart';

class AlertService {

  static final Box box = Hive.box('incidentsBox');

  static List<Map<String, dynamic>> getRecentIncidents() {

    final now = DateTime.now();

    return box.values.map((e) {

      final data = Map<String, dynamic>.from(e);

      final timeString = data["time"];

      if (timeString == null) return null;

      final time = DateTime.tryParse(timeString.toString());

      if (time == null) return null;

      final diff = now.difference(time).inHours;

      if (diff <= 24) return data;

      return null;

    }).whereType<Map<String, dynamic>>().toList();
  }

  static Map<String, int> getDailySummary() {

    int crime = 0;
    int accident = 0;
    int violence = 0;

    for (var e in box.values) {

      final i = Map<String, dynamic>.from(e);

      final cat = (i["category"] ?? "").toString().toLowerCase();

      if (cat == "crime") crime++;
      else if (cat == "accident") accident++;
      else if (cat == "violence") violence++;
    }

    return {
      "Crime": crime,
      "Accident": accident,
      "Violence": violence,
    };
  }
}