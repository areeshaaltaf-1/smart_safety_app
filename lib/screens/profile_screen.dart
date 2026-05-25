import 'dart:convert';
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
  String? imageBase64;

  final picker = ImagePicker();

  bool isVerified = false;
  String? cnicError;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() {
    final data = ProfileService.getProfile();

    nameController.text = data["name"] ?? "";
    cnicController.text = data["cnic"] ?? "";
    isVerified = data["verified"] ?? false;

    imageBase64 = data["image"];

    setState(() {});
  }

  String? validateCNIC(String value) {
    final regex = RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]{1}$');

    if (value.isEmpty) return "CNIC is required";
    if (!regex.hasMatch(value)) return "Format: 12345-1234567-1";

    return null;
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();

      setState(() {
        imageFile = File(picked.path);
        imageBase64 = base64Encode(bytes);
      });
    }
  }

  void saveProfile() {
    setState(() {
      cnicError = validateCNIC(cnicController.text);
    });

    if (cnicError != null) return;

    ProfileService.saveProfile({
      "name": nameController.text,
      "cnic": cnicController.text,
      "verified": isVerified,
      "image": imageBase64,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Saved Successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "USER PROFILE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.tealAccent,
                backgroundImage: imageBase64 != null
                    ? MemoryImage(base64Decode(imageBase64!))
                    : null,
                child: imageBase64 == null
                    ? const Icon(Icons.camera_alt, size: 30, color: Colors.black)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: inputStyle("Full Name"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: cnicController,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) {
                setState(() => cnicError = validateCNIC(v));
              },
              decoration: inputStyle("CNIC (XXXXX-XXXXXXX-X)")
                  .copyWith(errorText: cnicError),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Mark Verified",
                      style: TextStyle(color: Colors.white)),
                  Switch(
                    value: isVerified,
                    onChanged: (v) => setState(() => isVerified = v),
                    activeColor: Colors.tealAccent,
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                child: const Text("SAVE PROFILE"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF1F2937),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}