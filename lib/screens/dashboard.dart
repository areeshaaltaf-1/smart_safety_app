import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(12),
        children: const [
          Card(child: Center(child: Text("Report Incident"))),
          Card(child: Center(child: Text("Map"))),
          Card(child: Center(child: Text("Alerts"))),
          Card(child: Center(child: Text("Profile"))),
        ],
      ),
    );
  }
}