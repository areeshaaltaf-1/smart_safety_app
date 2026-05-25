import 'dart:async';
import 'package:flutter/material.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {

  bool emergencyActive = false;
  bool blink = false;

  Timer? timer;

  void activateSOS() {

    setState(() {
      emergencyActive = true;
    });

    timer = Timer.periodic(
      const Duration(milliseconds: 500),
          (_) {
        setState(() {
          blink = !blink;
        });
      },
    );
  }

  void stopSOS() {

    timer?.cancel();

    setState(() {
      emergencyActive = false;
      blink = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      emergencyActive
          ? (blink ? Colors.red : Colors.black)
          : const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("SOS Emergency"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.warning_amber_rounded,
              size: 120,
              color: emergencyActive
                  ? Colors.white
                  : Colors.redAccent,
            ),

            const SizedBox(height: 30),

            const Text(
              "EMERGENCY SOS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                emergencyActive
                    ? "Emergency mode activated!\nNearby people are alerted."
                    : "Tap the SOS button during emergencies.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(

              onTap: () {

                if (emergencyActive) {
                  stopSOS();
                } else {
                  activateSOS();
                }
              },

              child: AnimatedContainer(

                duration: const Duration(milliseconds: 300),

                width: 180,
                height: 180,

                decoration: BoxDecoration(
                  color: emergencyActive
                      ? Colors.red
                      : Colors.redAccent,

                  shape: BoxShape.circle,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),

                child: const Center(
                  child: Text(
                    "SOS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (emergencyActive)

              ElevatedButton(
                onPressed: stopSOS,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),

                child: const Text("STOP ALERT"),
              ),
          ],
        ),
      ),
    );
  }
}