import 'dart:async';

import 'package:flutter/material.dart';

Future<TimeOfDay?> pickStartTime(
  BuildContext context,
  TimeOfDay selectedTime,
) async {
  final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.dial,
  );

  if (timeOfDay != null) {
    return timeOfDay;
  }
  return null;
}
