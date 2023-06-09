import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wave/models/api.dart';

import 'package:wave/services/api.dart';
import 'package:wave/services/geolocator.dart';

class PatrolFormController extends ChangeNotifier {
  final patrolFormKey = GlobalKey<FormBuilderState>();
  final ApiService apiService;
  FetchState fetchState = FetchState.idle;
  GeolocatorService geolocatorService = GeolocatorService.getInstance();

  final endTimeController = TextEditingController();
  final placeController = TextEditingController();

  final endTimeFocusNode = FocusNode();
  final placeFocusNode = FocusNode();

  bool enabled = true;

  TimeOfDay? pickedTime;

  PatrolFormController(this.apiService);

  Future<Either<Exception, Patrol?>?> postPatrol(
      String notificationTitle, String notificationMessage) async {
    Either<Exception, Patrol?>? response;
    fetchState = FetchState.fetching;
    notifyListeners();
    if (patrolFormKey.currentState!.fields['endTime']!.value == null) {
      return null;
    }
    response = await apiService
        .createPatrol(patrolFormKey.currentState!.fields['endTime']!.value);
    response.fold(
      (_) => null,
      (r) async {
        geolocatorService.setSettings(
          notificationTitle,
          notificationMessage,
        );
        try {
          Position position =
              await geolocatorService.getPositionWithPermissionRequest();
        } catch (e) {
          Sentry.captureException(e);
        }
        geolocatorService.getStreamSubscription();
        fetchState = FetchState.fetched;
        pickedTime = null;
        disableFields();
        clearFields();
        notifyListeners();
      },
    );

    fetchState = FetchState.fetched;
    notifyListeners();
    return response;
  }

  Future<Either<Exception, Patrol?>?> updatePatrol() async {
    Either<Exception, Patrol?>? response;

    fetchState = FetchState.fetching;
    notifyListeners();
    DateTime endTimestamp =
        patrolFormKey.currentState!.fields['endTime']!.value;
    response = await apiService.updatePatrol(endTimestamp);
    response.fold((_) => null, (r) {
      disableFields();
    });
    fetchState = FetchState.fetched;
    notifyListeners();
    return response;
  }

  finishPatrol() async {
    fetchState = FetchState.fetching;
    notifyListeners();
    await geolocatorService.cancelPositionSubscription();
    await apiService.finishPatrol();
    fetchState = FetchState.fetched;
    notifyListeners();
    enableFields();
    clearFields();
    pickedTime = null;
  }

  clearFields() {
    endTimeController.clear();
  }

  disableFields() {
    enabled = false;
    notifyListeners();
  }

  enableFields() {
    enabled = true;
    notifyListeners();
  }
}
