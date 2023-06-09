import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:wave/models/api.dart';
import 'package:wave/providers/duty_form.dart';
import 'package:wave/providers/mobilisation_place.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/providers/status.dart';

///Dropdown search for picking [MobilisationPlace]
class MobilisationPlaceDropdown extends StatelessWidget {
  final GlobalKey<FormBuilderState> dutyFormKey;
  const MobilisationPlaceDropdown({Key? key, required this.dutyFormKey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer3<DutyFormController, MobilisationPlacesController,
        StatusController>(
      builder: (context, dutyForm, places, status, child) {
        return FormBuilderField(
          initialValue: status.activeDuty?.mobilisationPlace ??
              dutyForm.futureDuty?.mobilisationPlace,
          name: 'mobilisationPlace',
          builder: (field) => DropdownSearch<MobilisationPlace>(
            enabled: dutyForm.enabled,
            validator: (value) {
              if (value == null || value.name == '---') {
                return context.translated.selectMobilisationPointMessage;
              }
              return null;
            },
            popupProps: PopupProps.modalBottomSheet(
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(item.name!),
                );
              },
              showSearchBox: true,
              isFilterOnline: true,
              title: Center(
                heightFactor: 1.5,
                child: Text(
                  context.translated.searchTitle,
                  style: context.textTheme.bodyMedium,
                ),
              ),
              searchFieldProps: TextFieldProps(
                controller: dutyForm.dropdownController,
                decoration: InputDecoration(
                  hintText: context.translated.searchHint,
                ),
              ),
            ),
            dropdownBuilder: (context, selectedItem) {
              return Text(
                style: context.textTheme.displayLarge,
                selectedItem == null ? '' : selectedItem.name!,
              );
            },
            asyncItems: (String filter) async {
              await places.getMobilisationPlaces(filter);
              List<MobilisationPlace> models = places.places;
              return models;
            },
            itemAsString: (item) => item.name!,
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: const TextStyle(
                color: Colors.white,
              ),
              dropdownSearchDecoration: InputDecoration(
                labelText: context.translated.mobilisationPlace,
              ),
            ),
            onSaved: (newValue) {
              field.didChange(newValue);
              dutyFormKey.currentState!.validate();
            },
            onChanged: (value) {
              field.didChange(value);
              dutyFormKey.currentState!.validate();
            },
            selectedItem: status.activeDuty?.mobilisationPlace ??
                dutyForm.futureDuty?.mobilisationPlace,
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
        );
      },
    );
  }
}
