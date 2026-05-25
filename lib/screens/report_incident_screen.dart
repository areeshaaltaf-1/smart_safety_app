import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../services/incident_service.dart';
import '../services/profile_service.dart';

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

  // 📍 GPS
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

  // 📷 IMAGE
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

    // ⭐ VERIFICATION CHECK (IMPORTANT PART)
    if (severity == "High" && !ProfileService.isVerifiedUser()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Only VERIFIED users can report HIGH severity incidents"),
          backgroundColor: Colors.red,
        ),
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

      "lat": position?.latitude,
      "lng": position?.longitude,

      "image": imageBytes != null ? base64Encode(imageBytes!) : null,
      "time": DateTime.now().millisecondsSinceEpoch,
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
        centerTitle: true,
        backgroundColor: const Color(0xFF1F2937),
        title: const Text(
          "REPORT INCIDENT",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
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
            ),

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
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: submitIncident,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
              ),
              child: const Text("SUBMIT INCIDENT"),
            ),
          ],
        ),
      ),
    );
  }
}