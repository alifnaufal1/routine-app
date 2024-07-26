import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';

class EditRoutineUseCase implements UseCase<RoutineEntity, EditRoutineParams> {
  final RoutineRepository _repository;
  EditRoutineUseCase(this._repository);

  @override
  Future<Either<Failure, RoutineEntity>> call(EditRoutineParams params) async {
    return await _repository.editRoutine(
      id: params.id,
      title: params.title,
      startTime: params.startTime,
      day: params.day,
      categoryName: params.categoryName,
    );
  }
}

class EditRoutineParams {
  final int id;
  final String title;
  final TimeOfDay startTime;
  final String day;
  final String categoryName;

  EditRoutineParams({
    required this.id,
    required this.title,
    required this.startTime,
    required this.day,
    required this.categoryName,
  });
}
