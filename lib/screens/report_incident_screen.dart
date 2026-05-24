import 'package:flutter/material.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {

  final titleController = TextEditingController();
  final descController = TextEditingController();

  String? titleError;
  String? descError;

  String selectedCategory = "Theft";

  final List<String> categories = [
    "Theft",
    "Accident",
    "Harassment",
    "Suspicious Activity",
    "Other"
  ];

  void submitIncident() {

    setState(() {

      titleError = titleController.text.isEmpty
          ? "Title cannot be empty"
          : null;

      descError = descController.text.isEmpty
          ? "Description cannot be empty"
          : null;
    });

    if (titleError != null || descError != null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Incident Reported Successfully"),
      ),
    );

    titleController.clear();
    descController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF334155),
              Color(0xFF0F766E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(

          child: SingleChildScrollView(

            child: Column(

              children: [

                const Icon(
                  Icons.report,
                  size: 90,
                  color: Colors.white,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Report Incident",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // TITLE
                TextField(
                  controller: titleController,

                  onChanged: (_) {
                    setState(() {
                      titleError =
                      titleController.text.isEmpty
                          ? "Title required"
                          : null;
                    });
                  },

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Incident Title",
                    errorText: titleError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // DESCRIPTION
                TextField(
                  controller: descController,
                  maxLines: 3,

                  onChanged: (_) {
                    setState(() {
                      descError =
                      descController.text.isEmpty
                          ? "Description required"
                          : null;
                    });
                  },

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Description",
                    errorText: descError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CATEGORY
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    underline: const SizedBox(),

                    items: categories.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: submitIncident,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),

                    child: const Text("Submit Incident"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}