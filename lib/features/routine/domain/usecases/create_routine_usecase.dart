import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';

class CreateRoutineUseCase
    implements UseCase<RoutineEntity, CreateRoutineParams> {
  final RoutineRepository _repository;
  CreateRoutineUseCase(this._repository);

  @override
  Future<Either<Failure, RoutineEntity>> call(
      CreateRoutineParams params) async {
    return await _repository.createRoutine(
      title: params.title,
      startTime: params.startTime,
      day: params.day,
      categoryName: params.categoryName,
    );
  }
}

class CreateRoutineParams {
  final String title;
  final TimeOfDay startTime;
  final String day;
  final String categoryName;

  CreateRoutineParams({
    required this.title,
    required this.startTime,
    required this.day,
    required this.categoryName,
  });
}
