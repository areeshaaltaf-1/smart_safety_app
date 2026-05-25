import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../services/incident_service.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String category = "Crime";
  String severity = "Low";

  Uint8List? imageBytes;
  Position? position;

  bool loadingGPS = false;

  final picker = ImagePicker();

  // 📍 GPS (UNCHANGED)
  Future<void> getLocation() async {
    setState(() => loadingGPS = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => loadingGPS = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() => loadingGPS = false);
  }

  // 📷 IMAGE (WEB SAFE)
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();

      setState(() {
        imageBytes = bytes;
      });
    }
  }

  // 🚨 SUBMIT INCIDENT
  void submitIncident() async {

    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title required")),
      );
      return;
    }

    if (position == null) {
      await getLocation();
    }

    IncidentService.addIncident({
      "title": titleController.text,
      "description": descriptionController.text,
      "category": category,
      "severity": severity,

      // GPS
      "lat": position?.latitude,
      "lng": position?.longitude,

      // IMAGE
      "image": imageBytes != null ? base64Encode(imageBytes!) : null,

      "time": DateTime.now().toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Incident Reported")),
    );

    titleController.clear();
    descriptionController.clear();

    setState(() {
      imageBytes = null;
      position = null;
    });
  }

  // 🎨 INPUT FIELD
  Widget inputField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.tealAccent),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1F2937),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 🎨 DROPDOWN
  Widget dropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField(
        value: value,
        dropdownColor: const Color(0xFF1F2937),
        style: const TextStyle(color: Colors.white),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Report Incident"),
        backgroundColor: const Color(0xFF1F2937),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            inputField("Title", titleController, Icons.title),
            const SizedBox(height: 12),

            inputField("Description", descriptionController, Icons.description),
            const SizedBox(height: 12),

            dropdown("Category", category,
                ["Crime", "Accident", "Violence"], (v) {
                  setState(() => category = v!);
                }),

            const SizedBox(height: 12),

            dropdown("Severity", severity,
                ["Low", "Medium", "High"], (v) {
                  setState(() => severity = v!);
                }),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: getLocation,
              icon: const Icon(Icons.my_location),
              label: const Text("Get GPS Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (loadingGPS)
              const Text("Fetching GPS...", style: TextStyle(color: Colors.white70)),

            if (position != null)
              Text(
                "Lat: ${position!.latitude}, Lng: ${position!.longitude}",
                style: const TextStyle(color: Colors.white60),
              ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("Add Photo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            if (imageBytes != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    imageBytes!,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: submitIncident,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "SUBMIT INCIDENT",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}