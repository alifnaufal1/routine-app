import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';

class RoutineModel extends RoutineEntity {
  RoutineModel({
    int? id,
    required super.title,
    required super.startTime,
    required super.day,
    required super.category,
  }) : super(id: id ?? 0);

  
}
