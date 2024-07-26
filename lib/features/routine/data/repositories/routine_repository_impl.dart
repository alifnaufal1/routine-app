import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/exception.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/features/routine/data/datasources/routine_isar_data_source.dart';
import 'package:todolist_app/features/routine/data/models/category_model.dart';
import 'package:todolist_app/features/routine/data/models/routine_model.dart';
import 'package:todolist_app/features/routine/domain/entities/category_entity.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineIsarDataSource _dataSource;
  RoutineRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, CategoryEntity>> createCategory(
      String category) async {
    try {
      final createdCategory = await _dataSource.createCategory(category);
      return right(createdCategory);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategory() async {
    try {
      final fetchedCategories = await _dataSource.getAllCategory();
      return right(fetchedCategories);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, RoutineEntity>> createRoutine({
    required String title,
    required TimeOfDay startTime,
    required String day,
    required String categoryName,
  }) async {
    try {
      CategoryModel category;
      try {
        category = await _dataSource.getCategoryByName(categoryName);
      } catch (_) {
        category = await _dataSource.createCategory(categoryName);
      }

      RoutineModel routine = RoutineModel(
        id: null,
        title: title,
        startTime: startTime,
        day: day,
        category: category,
      );

      final createdRoutine = await _dataSource.createRoutine(routine);
      return right(createdRoutine);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<RoutineEntity>>> getAllRoutine() async {
    try {
      final fetchedRoutines = await _dataSource.getAllRoutine();
      return right(fetchedRoutines);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<RoutineEntity>>> getRoutineByCategories(
      List<String> categoryNames) async {
    try {
      final fetchedRoutines =
          await _dataSource.getRoutineByCategories(categoryNames);
      return right(fetchedRoutines);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, RoutineEntity>> editRoutine({
    required int id,
    required String title,
    required TimeOfDay startTime,
    required String day,
    required String categoryName,
  }) async {
    try {
      final category = await _getCategory(categoryName);

      RoutineModel routine = RoutineModel(
        id: id,
        title: title,
        startTime: startTime,
        day: day,
        category: category,
      );

      final updatedRoutine = await _dataSource.editRoutine(routine);
      return right(updatedRoutine);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<CategoryModel> _getCategory(String categoryName) async {
    CategoryModel category;
    try {
      category = await _dataSource.getCategoryByName(categoryName);
    } catch (_) {
      category = await _dataSource.createCategory(categoryName);
    }
    return category;
  }

  @override
  Future<Either<Failure, void>> deleteRoutine(int routineId) async {
    try {
      await _dataSource.deleteRoutine(routineId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
