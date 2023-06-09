import 'package:dio/dio.dart';

enum FetchState { fetching, fetched, idle }

class Patrol {
  final String? id;
  final Declaration declaration;

  Patrol(this.id, this.declaration);

  Patrol.fromJson(Response parsedJson)
      : id = parsedJson.data['id'],
        declaration = Declaration.fromJson(parsedJson.data['declaration']);

  Patrol.fromJsonBody(dynamic parsedJson)
      : id = parsedJson['id'],
        declaration = Declaration.fromJson(parsedJson['declaration']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'declaration': declaration,
      };

  static List<Patrol> fromJsonList(List list) {
    return list.map((item) => Patrol.fromJsonBody(item)).toList();
  }
}

class MobilisationPlace {
  final String id;
  String? name;
  LocationDto? location;

  MobilisationPlace.create(this.id);

  MobilisationPlace.example(this.id, this.name);

  MobilisationPlace.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        location = LocationDto.fromJson(parsedJson['location']);

  static List<MobilisationPlace> fromJsonList(List list) =>
      list.map((item) => MobilisationPlace.fromJson(item)).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class LocationDto {
  final double lat;
  final double lng;

  LocationDto(this.lat, this.lng);

  LocationDto.fromJson(Map<String, dynamic> parsedJson)
      : lat = parsedJson['lat']!,
        lng = parsedJson['lng']!;
}

class Declaration {
  DateTime? startTimestamp;
  final DateTime? endTimestamp;
  String? status;
  Declaration.duty(this.startTimestamp, this.endTimestamp);
  Declaration.patrol(this.endTimestamp);

  Declaration.fromJson(Map<String, dynamic> parsedJson)
      : startTimestamp =
            DateTime.parse(parsedJson['startTimestamp']!).toLocal(),
        endTimestamp = DateTime.parse(parsedJson['endTimestamp']!).toLocal(),
        status = parsedJson['status'];

  Map<String, dynamic> toJson() => {
        'startTimestamp': startTimestamp?.toUtc().toIso8601String(),
        'endTimestamp': endTimestamp?.toUtc().toIso8601String(),
      };
}

class Duty {
  String? id;
  String? ownerId;
  MobilisationPlace? mobilisationPlace;
  Declaration? declaration;
  int? mobilisationTime;
  bool? confirmation;

  Duty(this.declaration, this.mobilisationPlace, this.mobilisationTime);

  Duty.confirmation(this.id, this.confirmation);

  Duty.fromJson(Response parsedJson)
      : id = parsedJson.data['id'],
        ownerId = parsedJson.data['ownerId'],
        mobilisationPlace =
            MobilisationPlace.fromJson(parsedJson.data['mobilisationPlace']),
        declaration = Declaration.fromJson(parsedJson.data['declaration']),
        mobilisationTime = parsedJson.data['mobilisationTime'];

  Duty.fromJsonBody(dynamic parsedJson)
      : id = parsedJson['id'],
        ownerId = parsedJson['ownerId'],
        mobilisationPlace =
            MobilisationPlace.fromJson(parsedJson['mobilisationPlace']),
        declaration = Declaration.fromJson(parsedJson['declaration']),
        mobilisationTime = parsedJson['mobilisationTime'];

  Map<String, dynamic> toJson() => {
        'mobilisationPlace': mobilisationPlace?.toJson(),
        'declaration': declaration?.toJson(),
        'mobilisationTime': mobilisationTime,
      };
  Map<String, dynamic> toConfirmJson() => {
        'id': id,
        'confirmation': confirmation,
      };

  static List<Duty> fromJsonList(List list) =>
      list.map((item) => Duty.fromJsonBody(item)).toList();
}

class PatrolLocation {
  final int id;
  final String patrolId;
  final DateTime timestamp;
  final LocationDto location;

  PatrolLocation(this.id, this.patrolId, this.timestamp, this.location);

  PatrolLocation.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        patrolId = parsedJson['patrolId'],
        timestamp = DateTime.parse(parsedJson['timestamp']).toLocal(),
        location = LocationDto.fromJson(parsedJson['location']);

  static List<PatrolLocation> fromJsonList(List list) =>
      list.map((item) => PatrolLocation.fromJson(item)).toList();
}
