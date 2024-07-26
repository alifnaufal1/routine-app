import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:todolist_app/features/routine/data/collections/category.dart';

part 'routine.g.dart';

@Collection()
class Routine {
  Id id = Isar.autoIncrement;

  late String title;

  @Index()
  late String startTimeString;

  @Ignore()
  TimeOfDay get startTime {
    final parts = startTimeString.split(':');
    final minuteParts = parts[1].split(' ');
    final hour = int.parse(parts[0]);
    final minute = int.parse(minuteParts[0]);
    final period = minuteParts[1] == 'AM' ? DayPeriod.am : DayPeriod.pm;
    return TimeOfDay(
      hour: hour % 12 +
          (period == DayPeriod.pm
              ? 12
              : 0), // Kalo jamnya 17 (5 sore/pm), maka 17%12 = 5+12 = 17
      minute: minute,
    );
  }

  set startTime(TimeOfDay time) {
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    startTimeString =
        "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} $period";
  }

  @Index(caseSensitive: false)
  late String day;

  @Index(composite: [CompositeIndex('title')])
  final category = IsarLink<Category>();
}
