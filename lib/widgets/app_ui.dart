import 'package:flutter/material.dart';

class AppUI {

  // ⚡ ULTRA COMPACT INPUT STYLE
  static InputDecoration inputStyle(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
        fontSize: 13, // smaller label
      ),

      filled: true,
      fillColor: const Color(0xFF1F2937),

      isDense: true,

      // 🔥 REDUCED HEIGHT (IMPORTANT PART)
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // smaller radius
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.tealAccent),
      ),

      suffixIcon: suffix,
    );
  }

  // ⚡ ULTRA COMPACT BUTTON
  static ButtonStyle primaryButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.tealAccent,
      foregroundColor: Colors.black,

      minimumSize: const Size(double.infinity, 40), // 🔥 smaller height

      padding: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // 🎨 OPTIONAL: SMALL PAGE BACKGROUND (same theme)
  static const BoxDecoration background = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF0F172A),
        Color(0xFF111827),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}