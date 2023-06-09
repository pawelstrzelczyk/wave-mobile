import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wave/services/api.dart';
import 'package:wave/services/mqtt.dart';

class GeolocatorService {
  late LocationSettings locationSettings;
  StreamSubscription<Position>? positionStream;
  Stream<ServiceStatus>? serviceStatusStream;
  MqttService mqttService = MqttService(ApiService.getInstance());
  static final GeolocatorService geolocatorService = GeolocatorService._();
  GeolocatorService._();

  static GeolocatorService getInstance() {
    return geolocatorService;
  }

  setSettings(String title, String message) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(hours: 16),
        intervalDuration: const Duration(seconds: 15),
        foregroundNotificationConfig: ForegroundNotificationConfig(
          notificationTitle: title,
          notificationText: message,
          notificationIcon: const AndroidResource(
            name: 'patrol_notification_white',
            defType: 'mipmap',
          ),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(hours: 16),
        allowBackgroundLocationUpdates: true,
        showBackgroundLocationIndicator: true,
        pauseLocationUpdatesAutomatically: true,
        distanceFilter: 2,
      );
    }
  }

  StreamSubscription<Position> getStreamSubscription() {
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        mqttService.preparePayloadAndPublish(
          DateTime.now().toUtc(),
          LatLng(position.latitude, position.longitude),
        );
        log('location sent: ${DateTime.now()} \nlat: ${position.latitude} long: ${position.longitude}');
      },
      onError: (Object e) {
        Sentry.captureException(e);
      },
      cancelOnError: false,
    );

    return positionStream!;
  }

  Future<Position> getPositionWithPermissionRequest() async {
    bool serviceEnabled;
    LocationPermission currentPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service disabled');
    }

    currentPermission = await Geolocator.checkPermission();
    if (currentPermission == LocationPermission.denied) {
      currentPermission = await Geolocator.requestPermission();
      if (currentPermission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (currentPermission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied forever');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> cancelPositionSubscription() async {
    if (positionStream == null || positionStream!.isPaused) {
      return;
    }
    await positionStream?.cancel();
    if (mqttService.client.connectionStatus!.state ==
            MqttConnectionState.disconnected ||
        mqttService.client.connectionStatus!.state ==
            MqttConnectionState.disconnecting ||
        mqttService.client.connectionStatus!.state ==
            MqttConnectionState.faulted) {
      return;
    }
    mqttService.client.disconnect();
  }

  Future<Stream<ServiceStatus>> getServiceStatus() async {
    return serviceStatusStream = Geolocator.getServiceStatusStream();
  }

  Future<LocationAccuracyStatus?> getAccuracyStatus() async {
    LocationAccuracyStatus? locationAccuracyStatus;
    try {
      if (await Geolocator.isLocationServiceEnabled()) {
        locationAccuracyStatus = await Geolocator.getLocationAccuracy();
        return locationAccuracyStatus;
      } else {
        return LocationAccuracyStatus.unknown;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  MqttConnectionState getMqttConnectionState() {
    return mqttService.client.connectionStatus!.state;
  }
}
