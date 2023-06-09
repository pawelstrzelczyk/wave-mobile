import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

///Custom [Marker] used in [FlutterMap]
class WaveMapMarker {
  final BuildContext context;
  final LocationData currentLocation;
  WaveMapMarker(this.currentLocation, this.context);

  Marker get waveMarker => Marker(
        point: LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        ),
        builder: (context) {
          return Stack(
            children: [
              Center(
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        },
      );
}
