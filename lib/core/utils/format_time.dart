import 'package:flutter/material.dart';

String formatStartTime(TimeOfDay selectedTime) {
  return "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name}";
}
