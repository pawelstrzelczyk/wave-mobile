import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:wave/models/api.dart';
import 'package:wave/services/api.dart';

enum UserStatus { duty, patrol, idle }

enum LocationStatus { ok, bad }

class StatusController extends ChangeNotifier {
  final ApiService apiService;
  StatusController(this.apiService);

  FetchState fetchState = FetchState.idle;
  UserStatus activeStatus = UserStatus.idle;
  Patrol? activePatrol;
  Duty? activeDuty;
  DateTime? startTimestamp;
  DateTime? endTimestamp;
  int mobilisationTime = 0;
  MobilisationPlace? mobilisationPlace;

  getStatus() async {
    fetchState = FetchState.fetching;
    notifyListeners();
    var status = await apiService.getActiveStatus();
    if (status is Duty) {
      activeDuty = status;
      activeStatus = UserStatus.duty;
      startTimestamp = activeDuty!.declaration!.startTimestamp!;
      endTimestamp = activeDuty!.declaration!.endTimestamp!;
      mobilisationTime = activeDuty!.mobilisationTime!;
      mobilisationPlace = activeDuty!.mobilisationPlace;
    } else if (status is Patrol) {
      activePatrol = status;
      activeStatus = UserStatus.patrol;
      startTimestamp = activePatrol!.declaration.startTimestamp!;
      endTimestamp = activePatrol!.declaration.endTimestamp!;
    } else {
      activeDuty = null;
      activePatrol = null;
      activeStatus = UserStatus.idle;
    }
    fetchState = FetchState.fetched;
    notifyListeners();
  }

  Future<Either<Exception, bool?>> confirmDuty(bool confirmation) async {
    return await apiService.confirmDuty(confirmation);
  }
}
