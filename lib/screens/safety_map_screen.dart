import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/incident_service.dart';

class SafetyMapScreen extends StatefulWidget {
  const SafetyMapScreen({super.key});

  @override
  State<SafetyMapScreen> createState() => _SafetyMapScreenState();
}

class _SafetyMapScreenState extends State<SafetyMapScreen> {

  List<Map<String, dynamic>> incidents = [];

  @override
  void initState() {
    super.initState();
    loadIncidents();
  }

  void loadIncidents() {
    incidents = IncidentService.getIncidents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    const LatLng center = LatLng(33.6844, 73.0479);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Map"),
        backgroundColor: const Color(0xFF1E293B),
      ),

      body: FlutterMap(
        options: const MapOptions(
          initialCenter: center,
          initialZoom: 13,
        ),

        children: [

          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),

          MarkerLayer(
            markers: incidents.map((incident) {

              final lat = incident["lat"];
              final lng = incident["lng"];

              if (lat == null || lng == null) {
                return Marker(
                  point: center,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.error, color: Colors.red),
                );
              }

              return Marker(
                point: LatLng(lat, lng),
                width: 45,
                height: 45,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 35,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}