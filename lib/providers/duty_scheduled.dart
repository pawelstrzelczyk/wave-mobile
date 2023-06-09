import 'package:flutter/material.dart';
import 'package:wave/models/api.dart';
import 'package:wave/services/api.dart';

class DutyFutureController extends ChangeNotifier {
  final ApiService apiService;
  FetchState fetchState = FetchState.idle;
  List<Duty> duties = [];

  int limit = 10;
  int page = 0;

  DutyFutureController(this.apiService);

  SortType sortType = SortType.desc;

  SortCryteria sortCryteria = SortCryteria.startTimestamp;
  getScheduledDuties() async {
    var pastDutiesResponse = await apiService.getScheduledDuties(
        page, limit, sortCryteria, sortType);
    duties.addAll(Duty.fromJsonList(pastDutiesResponse ?? []));
  }

  setSortType(SortType sortType) {
    this.sortType = sortType;
    notifyListeners();
  }
}
