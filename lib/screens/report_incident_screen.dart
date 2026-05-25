import 'package:flutter/material.dart';
import '../services/incident_service.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedSeverity = "Low";
  String selectedCategory = "Crime";

  void submitIncident() {

    if (titleController.text.isEmpty || locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    IncidentService.addIncident({
      "title": titleController.text,
      "location": locationController.text,
      "description": descriptionController.text,
      "severity": selectedSeverity,
      "category": selectedCategory,
      "time": DateTime.now().toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Incident Reported Successfully")),
    );

    titleController.clear();
    locationController.clear();
    descriptionController.clear();

    setState(() {});
  }

  Widget buildField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Incident"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFF1F5F9),

        child: SingleChildScrollView(
          child: Column(
            children: [

              buildField("Incident Title", titleController, Icons.title),
              const SizedBox(height: 12),

              buildField("Location", locationController, Icons.location_on),
              const SizedBox(height: 12),

              buildField("Description", descriptionController, Icons.description),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField(
                  value: selectedSeverity,
                  items: const [
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "High", child: Text("High")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedSeverity = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Severity",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField(
                  value: selectedCategory,
                  items: const [
                    DropdownMenuItem(value: "Crime", child: Text("Crime")),
                    DropdownMenuItem(value: "Accident", child: Text("Accident")),
                    DropdownMenuItem(value: "Violence", child: Text("Violence")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitIncident,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                  ),
                  child: const Text("Submit Incident"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}