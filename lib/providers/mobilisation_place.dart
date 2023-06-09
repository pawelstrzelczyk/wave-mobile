import 'package:flutter/material.dart';
import 'package:wave/models/api.dart';
import 'package:wave/services/api.dart';

class MobilisationPlacesController extends ChangeNotifier {
  final ApiService apiService;
  FetchState fetchState = FetchState.idle;

  List<MobilisationPlace> places = [];

  MobilisationPlacesController(this.apiService);

  Future<void> getMobilisationPlaces(String filter) async {
    fetchState = FetchState.fetching;
    notifyListeners();

    var mobilisationPlaceResponse =
        await apiService.getMobilisationPlaces(filter);
    places.clear();
    places.addAll(MobilisationPlace.fromJsonList(mobilisationPlaceResponse!));
    fetchState = FetchState.fetched;
    notifyListeners();
  }
}
