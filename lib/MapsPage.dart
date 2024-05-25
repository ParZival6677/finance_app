import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(51.1694, 71.4491),
              zoom: 10,
              minZoom: 1,
              maxBounds: LatLngBounds(
                LatLng(-85.0, -180.0),
                LatLng(85.0, 180.0),
              ),
            ),

            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      _mapController.move(_mapController.center, _mapController.zoom + 1);
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 42.0,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      _mapController.move(_mapController.center, _mapController.zoom - 1);
                    },
                    icon: Icon(
                      Icons.remove,
                      color: Colors.black,
                      size: 42.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
