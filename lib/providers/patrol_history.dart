import 'package:flutter/material.dart';
import 'package:wave/models/api.dart';
import 'package:wave/services/api.dart';

class PatrolHistoryController extends ChangeNotifier {
  final ApiService apiService;

  List<Patrol> patrols = [];

  int limit = 10;
  int page = 0;

  SortType sortType = SortType.desc;
  SortCryteria sortCryteria = SortCryteria.startTimestamp;

  PatrolHistoryController(this.apiService);
  getPastPatrols() async {
    var pastPatrolsResponse =
        await apiService.getPastPatrols(page, limit, sortCryteria, sortType);
    patrols.addAll(Patrol.fromJsonList(pastPatrolsResponse));
  }

  setSortType(SortType sortType) {
    this.sortType = sortType;
    notifyListeners();
  }
}
