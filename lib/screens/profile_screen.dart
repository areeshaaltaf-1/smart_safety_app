import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final nameController = TextEditingController();
  final cnicController = TextEditingController();

  File? imageFile;

  final picker = ImagePicker();

  bool isVerified = false;

  String? cnicError;

  // 📌 CNIC VALIDATION
  String? validateCNIC(String value) {

    final regex = RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]{1}$');

    if (value.isEmpty) {
      return "CNIC is required";
    }

    if (!regex.hasMatch(value)) {
      return "Format: 12345-1234567-1";
    }

    return null;
  }

  // 📷 PICK IMAGE
  Future<void> pickImage() async {

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // 💾 SAVE PROFILE
  void saveProfile() {

    setState(() {
      cnicError = validateCNIC(cnicController.text);
    });

    if (cnicError != null) return;

    ProfileService.saveProfile({
      "name": nameController.text,
      "cnic": cnicController.text,
      "verified": isVerified,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Saved Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            // 📷 PROFILE IMAGE
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.tealAccent,
                backgroundImage:
                imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? const Icon(Icons.camera_alt,
                    color: Colors.black, size: 30)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            // NAME FIELD
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Full Name",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1F2937),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // CNIC FIELD
            TextField(
              controller: cnicController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  cnicError = validateCNIC(value);
                });
              },
              decoration: InputDecoration(
                labelText: "CNIC (XXXXX-XXXXXXX-X)",
                labelStyle: const TextStyle(color: Colors.white70),
                errorText: cnicError,
                filled: true,
                fillColor: const Color(0xFF1F2937),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // VERIFIED SWITCH
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Mark as Verified User",
                    style: TextStyle(color: Colors.white),
                  ),

                  Switch(
                    value: isVerified,
                    activeColor: Colors.tealAccent,
                    onChanged: (value) {
                      setState(() {
                        isVerified = value;
                      });
                    },
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "SAVE PROFILE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}