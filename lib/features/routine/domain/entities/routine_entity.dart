import 'package:flutter/material.dart';
import 'package:todolist_app/features/routine/domain/entities/category_entity.dart';

class RoutineEntity {
  final int id;
  final String title;
  final TimeOfDay startTime;
  final String day;
  final CategoryEntity category;

  RoutineEntity({
    required this.id,
    required this.title,
    required this.startTime,
    required this.day,
    required this.category,
  });
}
