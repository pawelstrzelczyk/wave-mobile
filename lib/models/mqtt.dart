import 'package:latlong2/latlong.dart';

class Payload {
  final String timestamp;
  final MqttLocation location;
  final String patrolId;

  Payload(this.timestamp, this.location, this.patrolId);

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'location': location.toJson(),
        'patrolId': patrolId,
      };
}

class MqttLocation {
  final LatLng latLng;

  MqttLocation(this.latLng);

  Map<String, dynamic> toJson() => {
        'lat': latLng.latitude,
        'lng': latLng.longitude,
      };
}

class MqttPatrolExpirationMessage {
  final String? expiredDeclarationId;

  MqttPatrolExpirationMessage.fromJson(Map<String, dynamic> json)
      : expiredDeclarationId = json['expiredDeclarationId'];
}
