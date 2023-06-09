import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wave/components/custom_action_button.dart';
import 'package:wave/components/material_components/custom_error_dialog.dart';
import 'package:wave/components/custom_ui_constants/icons.dart';
import 'package:wave/components/mobilisation_place_dropdown_search.dart';
import 'package:wave/components/material_components/status_page_appbar.dart';
import 'package:wave/models/api.dart';
import 'package:wave/providers/duty_form.dart';
import 'package:wave/providers/status.dart';
import 'package:wave/extensions/context.dart';

class DutyPage extends StatefulWidget {
  const DutyPage({Key? key}) : super(key: key);

  @override
  State<DutyPage> createState() => _DutyPageState();
}

class _DutyPageState extends State<DutyPage> {
  final dutyFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(
        tabs: false,
        title: context.translated.dutyTitle,
        icon: WaveIcons().dutyIcon,
        topColor: const Color(0xff4CAF50),
        bottomColor: const Color(0xfc051f37).withOpacity(0),
        height: context.height * 0.16,
      ),
      body: Consumer2<DutyFormController, StatusController>(
        builder: (consumerContext, dutyForm, status, child) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: context.width * .1,
                  right: context.width * .1,
                  top: context.width * .1,
                ),
                child: buildDutyForm(dutyForm, context, status),
              ),
              dutyForm.fetchState == FetchState.fetching
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : BackdropFilter(
                      filter: ImageFilter.blur(),
                    ),
            ],
          );
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  FormBuilder buildDutyForm(DutyFormController dutyForm, BuildContext context,
      StatusController status) {
    return FormBuilder(
      enabled: dutyForm.enabled,
      key: dutyFormKey,
      child: SingleChildScrollView(
        child: SizedBox(
          height: context.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              dutyForm.isPlanning
                  ? Expanded(
                      flex: 0,
                      child: FormBuilderDateTimePicker(
                        name: 'startDateTime',
                        initialValue: status
                                .activeDuty?.declaration?.startTimestamp ??
                            dutyForm.futureDuty?.declaration?.startTimestamp,
                        initialTime: TimeOfDay.fromDateTime(
                          DateTime.now().add(
                            const Duration(minutes: 5),
                          ),
                        ),
                        decoration: InputDecoration(
                          labelText: context.translated.scheduledStartDate,
                        ),
                        selectableDayPredicate: (day) {
                          return day.isAfter(
                              DateTime.now().subtract(const Duration(days: 1)));
                        },
                        validator: (value) {
                          if (value == null) {
                            return context.translated.enterDateMessage;
                          } else if (value.isBefore(
                            DateTime.now().add(
                              const Duration(minutes: 5),
                            ),
                          )) {
                            return context
                                .translated.startTimeBeforeStartMessageOnCreate;
                          }
                          return null;
                        },
                        format: DateFormat.yMd(
                          // 'dd.MM.yyyy HH:mm',
                          context.translated.localeName,
                        ).add_Hm(),
                        onChanged: (value) {
                          dutyFormKey.currentState!.saveAndValidate();
                          dutyForm.setStartFutureDate(value);
                        },
                        controller: dutyForm.startDateController,
                        focusNode: dutyForm.startDateFocusNode,
                        style: context.textTheme.displayLarge,
                      ),
                    )
                  : const SizedBox.shrink(),
              Expanded(
                flex: 0,
                child: FormBuilderDateTimePicker(
                  name: 'endDateTime',
                  initialValue: status.activeDuty?.declaration?.endTimestamp ??
                      dutyForm.futureDuty?.declaration?.endTimestamp,
                  decoration: InputDecoration(
                    labelText: context.translated.scheduledEndDate,
                  ),
                  initialTime: TimeOfDay.fromDateTime(
                    dutyForm.startFutureDate ?? DateTime.now(),
                  ),
                  initialDate: dutyForm.startFutureDate,
                  selectableDayPredicate: (day) {
                    return !dutyForm.isPlanning
                        ? day.isAfter(DateTime.now()
                                .subtract(const Duration(days: 1))) &&
                            day.isBefore(
                                DateTime.now().add(const Duration(days: 1)))
                        : dutyForm.startFutureDate != null
                            ? day.isAfter(
                                dutyForm.startFutureDate!.subtract(
                                  const Duration(days: 1),
                                ),
                              )
                            : day.isAfter(DateTime.now()
                                .subtract(const Duration(days: 1)));
                  },
                  validator: (value) {
                    if (value == null) {
                      return context.translated.enterDateMessage;
                    } else if (value.isBefore(DateTime.now())) {
                      return context
                          .translated.endTimeBeforeStartMessageOnCreate;
                    } else if ((dutyFormKey
                            .currentState!.fields['startDateTime'] !=
                        null)) {
                      if (dutyFormKey
                              .currentState!.fields['startDateTime']!.value !=
                          null) {
                        if ((dutyFormKey.currentState!.fields['startDateTime']!
                                .value as DateTime)
                            .isAfter(value)) {
                          return context
                              .translated.endTimeBeforeStartMessageOnEdit;
                        }
                      }
                    }

                    return null;
                  },
                  format: DateFormat.yMd(
                    // 'dd.MM.yyyy HH:mm',
                    context.translated.localeName,
                  ).add_Hm(),
                  onChanged: (value) => dutyFormKey.currentState!.validate(),
                  controller: dutyForm.endDateController,
                  focusNode: dutyForm.endDateFocusNode,
                  style: context.textTheme.displayLarge,
                ),
              ),
              Expanded(
                flex: 0,
                child: MobilisationPlaceDropdown(
                  dutyFormKey: dutyFormKey,
                ),
              ),
              Expanded(
                flex: 0,
                child: FormBuilderSlider(
                  name: 'mobilisationTime',
                  initialValue:
                      status.activeDuty?.mobilisationTime?.toDouble() ??
                          dutyForm.futureDuty?.mobilisationTime?.toDouble() ??
                          15.0,
                  decoration: InputDecoration(
                    labelText: context.translated.mobilisationTime,
                  ),
                  label: dutyForm.sliderLabel,
                  onChanged: (value) {
                    if (value == null) return;
                    if (value == 1) {
                      dutyForm.setStringLabel(
                          context.translated.sliderLabelOneMinute);
                    } else if (value > 1 && value < 5) {
                      dutyForm.setStringLabel(
                          context.translated.sliderLabelMinutesFew);
                    } else {
                      dutyForm.setStringLabel(
                          context.translated.sliderLabelMinutes);
                    }
                  },
                  inactiveColor: Colors.grey,
                  divisions: 30,
                  min: 0,
                  max: 30,
                  activeColor: context.theme.progressIndicatorTheme.color,
                ),
              ),
              dutyForm.isPlanning && dutyForm.futureDuty != null
                  ? Flexible(
                      flex: 1,
                      child: CustomActionButton(
                        externalContext: context,
                        () async {
                          final navigator = context.router;
                          if (dutyFormKey.currentState?.saveAndValidate() ??
                              false) {
                            navigator.pop();
                            await dutyForm.updateDuty(
                                dutyForm.futureDuty?.id, dutyFormKey);
                            dutyForm.startFutureDate = null;

                            if (dutyForm.fetchState == FetchState.fetched) {
                              await navigator.pop();
                              dutyForm.disableFields();
                            }
                          } else {
                            await navigator.pop();
                          }
                        },
                        icon: WaveIcons().saveButtonIcon,
                        text: context.translated.save,
                        dialogTitle: context.translated.confirmSave,
                        dialogMessage: context.translated.confirmSchedule,
                      ),
                    )
                  : status.activeStatus != UserStatus.duty
                      ? Flexible(
                          flex: 1,
                          child: CustomActionButton(
                            externalContext: context,
                            () async {
                              final navigator = context.router;
                              if (dutyFormKey.currentState?.saveAndValidate() ??
                                  false) {
                                await navigator.pop();
                                dutyForm
                                    .postDutyForm(dutyFormKey)
                                    .then((value) async {
                                  value?.fold(
                                    (l) => CustomErrorDialog(
                                            context.translated.badRequest,
                                            l.toString())
                                        .showCustomDialog(context),
                                    (r) async {
                                      if (dutyForm.fetchState ==
                                          FetchState.fetched) {
                                        await navigator.pop();
                                        dutyForm.disableFields();
                                      }
                                    },
                                  );
                                });
                              } else {
                                await navigator.pop();
                              }
                            },
                            icon: WaveIcons().sendButtonIcon,
                            text: context.translated.send,
                            dialogTitle: context.translated.confirmDuty,
                            dialogMessage: context.translated.confirmSchedule,
                          ),
                        )
                      : dutyForm.enabled
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: CustomActionButton(
                                    externalContext: context,
                                    () async {
                                      dutyFormKey.currentState!.reset();
                                      dutyForm.disableFields();
                                      await context.router.pop();
                                    },
                                    icon: WaveIcons().cancelButtonIcon,
                                    text: context.translated.cancel,
                                    dialogTitle: context.translated.cancelSave,
                                    dialogMessage:
                                        context.translated.cancelChanges,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: CustomActionButton(
                                    externalContext: context,
                                    () async {
                                      final navigator = context.router;
                                      await navigator.pop();
                                      if (dutyFormKey.currentState
                                              ?.validate() ??
                                          false) {
                                        dutyForm
                                            .updateDuty(null, dutyFormKey)
                                            .then((value) async {
                                          value?.fold(
                                            (l) => CustomErrorDialog(
                                                    context
                                                        .translated.badRequest,
                                                    l.toString())
                                                .showCustomDialog(context),
                                            (r) async {
                                              if (dutyForm.fetchState ==
                                                  FetchState.fetched) {
                                                await navigator.pop();
                                              }
                                            },
                                          );
                                        });
                                      } else {
                                        await navigator.pop();
                                      }
                                    },
                                    icon: WaveIcons().saveButtonIcon,
                                    text: context.translated.save,
                                    dialogTitle: context.translated.confirmSave,
                                    dialogMessage:
                                        context.translated.confirmChanges,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomActionButton(
                                  externalContext: context,
                                  () async {
                                    dutyForm.enableFields();
                                    await context.router.pop();
                                  },
                                  icon: WaveIcons().editButtonIcon,
                                  text: context.translated.edit,
                                  dialogTitle: context.translated.editDuty,
                                  dialogMessage:
                                      context.translated.confirmEditDuty,
                                ),
                                CustomActionButton(
                                  externalContext: context,
                                  () async {
                                    final navigator = context.router;
                                    await navigator.pop();
                                    await dutyForm.finishDuty();
                                    if (dutyForm.fetchState ==
                                        FetchState.fetched) {}
                                    await navigator.pop();
                                  },
                                  icon: Icons.flag_outlined,
                                  text: context.translated.delete,
                                  dialogTitle: context.translated.warning,
                                  dialogMessage:
                                      context.translated.confirmFinish,
                                ),
                              ],
                            )
            ],
          ),
        ),
      ),
    );
  }
}
