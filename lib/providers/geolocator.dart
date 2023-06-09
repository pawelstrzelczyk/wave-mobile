import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:wave/services/geolocator.dart';

class GeolocatorController extends ChangeNotifier {
  final GeolocatorService geolocatorService;

  LocationAccuracyStatus? locationAccuracyStatus;
  MqttConnectionState? mqttConnectionState;

  GeolocatorController(this.geolocatorService);

  setSettings(DateTime endTimestamp, String title, String message) {
    geolocatorService.setSettings(title, message);
  }

  getAccuracy() async {
    locationAccuracyStatus = await geolocatorService.getAccuracyStatus();
    notifyListeners();
  }

  getMqttState() {
    mqttConnectionState = geolocatorService.getMqttConnectionState();
    notifyListeners();
  }
}
