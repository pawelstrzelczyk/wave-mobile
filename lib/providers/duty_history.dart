import 'package:flutter/material.dart';
import 'package:wave/models/api.dart';
import 'package:wave/services/api.dart';

class DutyHistoryController extends ChangeNotifier {
  final ApiService apiService;
  FetchState fetchState = FetchState.idle;

  List<Duty> duties = [];

  int limit = 10;
  int page = 0;

  DutyHistoryController(this.apiService);

  SortType sortType = SortType.desc;

  SortCryteria sortCryteria = SortCryteria.startTimestamp;

  getPastDuties() async {
    var pastDutiesResponse =
        await apiService.getPastDuties(page, limit, sortCryteria, sortType);
    duties.addAll(Duty.fromJsonList(pastDutiesResponse));
  }

  setSortType(SortType sortType) {
    this.sortType = sortType;
    notifyListeners();
  }
}
