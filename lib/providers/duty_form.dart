import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:wave/models/api.dart';
import 'package:wave/services/api.dart';

class DutyFormController extends ChangeNotifier {
  FetchState fetchState = FetchState.idle;
  final ApiService apiService;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final mobTimeController = TextEditingController();
  final dropdownController = TextEditingController();

  final startDateFocusNode = FocusNode();
  final endDateFocusNode = FocusNode();
  final mobTimeFocusNode = FocusNode();

  String sliderLabel = '';

  setStringLabel(String value) {
    sliderLabel = value;
    notifyListeners();
  }

  DateTime? startFutureDate;

  Duty? futureDuty;

  bool isActive = false;

  bool isPlanning = false;

  bool enabled = true;

  DutyFormController(this.apiService);

  Future<Either<Exception, Duty?>?> postDutyForm(
    GlobalKey<FormBuilderState> dutyFormKey,
  ) async {
    fetchState = FetchState.fetching;
    notifyListeners();

    Either<Exception, Duty?>? response;

    if (dutyFormKey.currentState == null) {
      fetchState = FetchState.fetched;
      notifyListeners();
      return null;
    }
    if (dutyFormKey.currentState!.fields.isNotEmpty) {
      if (dutyFormKey.currentState!.fields['startDateTime'] == null) {
        response = await apiService.createDuty(
          null,
          dutyFormKey.currentState!.fields['endDateTime']!.value,
          (dutyFormKey.currentState!.fields['mobilisationTime']!.value
                  as double)
              .toInt(),
          dutyFormKey.currentState!.fields['mobilisationPlace']!.value,
        );
      } else {
        response = await apiService.createDuty(
          dutyFormKey.currentState!.fields['startDateTime']!.value,
          dutyFormKey.currentState!.fields['endDateTime']!.value,
          (dutyFormKey.currentState!.fields['mobilisationTime']!.value
                  as double)
              .toInt(),
          dutyFormKey.currentState!.fields['mobilisationPlace']!.value,
        );
      }

      fetchState = FetchState.fetched;
      notifyListeners();

      response.fold(
        (_) => null,
        (r) => () {
          if (r is Duty && isPlanning) {
            isPlanning = false;
          }
          disableFields();
        },
      );
    }

    return response;
  }

  Future<Either<Exception, Duty?>?> updateDuty(
      String? id, GlobalKey<FormBuilderState> dutyFormKey) async {
    fetchState = FetchState.fetching;
    notifyListeners();

    Either<Exception, Duty?>? response;

    if (dutyFormKey.currentState!.fields['startDateTime'] == null) {
      response = await apiService.updateDuty(
        id,
        null,
        dutyFormKey.currentState!.fields['endDateTime']!.value,
        (dutyFormKey.currentState!.fields['mobilisationTime']!.value as double)
            .toInt(),
        dutyFormKey.currentState!.fields['mobilisationPlace']!.value,
      );
    } else {
      response = await apiService.updateDuty(
        id,
        dutyFormKey.currentState!.fields['startDateTime']!.value,
        dutyFormKey.currentState!.fields['endDateTime']!.value,
        (dutyFormKey.currentState!.fields['mobilisationTime']!.value as double)
            .toInt(),
        dutyFormKey.currentState!.fields['mobilisationPlace']!.value,
      );
    }

    response.fold((_) => null, (r) {
      disableFields();
    });

    fetchState = FetchState.fetched;
    notifyListeners();

    return response;
  }

  deleteDuty(String dutyId) async {
    fetchState = FetchState.fetching;
    notifyListeners();

    await apiService.deleteFutureDuty(dutyId);
    fetchState = FetchState.fetched;

    enableFields();
    notifyListeners();
  }

  finishDuty() async {
    fetchState = FetchState.fetching;
    notifyListeners();

    await apiService.finishDuty();
    fetchState = FetchState.fetched;

    enableFields();
    notifyListeners();
  }

  disableFields() {
    enabled = false;
    notifyListeners();
  }

  enableFields() {
    enabled = true;
    notifyListeners();
  }

  setStartFutureDate(DateTime? date) {
    startFutureDate = date;
    notifyListeners();
  }
}
