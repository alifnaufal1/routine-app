import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/features/routine/domain/entities/category_entity.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';

abstract class RoutineRepository {
  Future<Either<Failure, CategoryEntity>> createCategory(String category);
  Future<Either<Failure, List<CategoryEntity>>> getAllCategory();
  Future<Either<Failure, RoutineEntity>> createRoutine({
    required String title,
    required TimeOfDay startTime,
    required String day,
    required String categoryName,
  });
  Future<Either<Failure, List<RoutineEntity>>> getAllRoutine();
  Future<Either<Failure, List<RoutineEntity>>> getRoutineByCategories(
    List<String> categoryNames,
  );
  Future<Either<Failure, RoutineEntity>> editRoutine({
    required int id,
    required String title,
    required TimeOfDay startTime,
    required String day,
    required String categoryName,
  });
  Future<Either<Failure, void>> deleteRoutine(int routineId);
}
