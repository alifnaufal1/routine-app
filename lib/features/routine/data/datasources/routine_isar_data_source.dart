import 'package:isar/isar.dart';
import 'package:todolist_app/features/routine/data/collections/category.dart';
import 'package:todolist_app/features/routine/data/collections/routine.dart';
import 'package:todolist_app/core/errors/exception.dart';
import 'package:todolist_app/features/routine/data/models/category_model.dart';
import 'package:todolist_app/features/routine/data/models/routine_model.dart';

abstract class RoutineIsarDataSource {
  Future<CategoryModel> createCategory(String category);
  Future<List<CategoryModel>> getAllCategory();
  Future<RoutineModel> createRoutine(RoutineModel routine);
  Future<CategoryModel> getCategoryByName(String name);
  Future<List<RoutineModel>> getAllRoutine();
  Future<List<RoutineModel>> getRoutineByCategories(List<String> categoryNames);
  Future<RoutineModel> editRoutine(RoutineModel routine);
  Future<void> deleteRoutine(int routineId);
}

class RoutineIsarDataSourceImpl implements RoutineIsarDataSource {
  final Isar _isar;
  RoutineIsarDataSourceImpl(this._isar);

  @override
  Future<CategoryModel> createCategory(String category) async {
    try {
      final categories = Category()..categoryName = category;
      await _isar.writeTxn(() async {
        await _isar.categorys.put(categories);
      });
      return CategoryModel(
        id: categories.id,
        categoryName: categories.categoryName,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategory() async {
    try {
      final allCategory = await _isar.categorys.where().findAll();
      return allCategory
          .map(
            (e) => CategoryModel(
              id: e.id,
              categoryName: e.categoryName,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoutineModel> createRoutine(RoutineModel routine) async {
    try {
      final category = Category()
        ..id = routine.category.id
        ..categoryName = routine.category.categoryName;

      final newRoutine = Routine()
        ..title = routine.title
        ..startTime = routine.startTime
        ..day = routine.day
        ..category.value = category;

      await _isar.writeTxn(() async {
        await _isar.routines.put(newRoutine);
        await _isar.categorys.put(category);
        await newRoutine.category.save();
      });

      return RoutineModel(
        id: newRoutine.id,
        title: newRoutine.title,
        startTime: newRoutine.startTime,
        day: newRoutine.day,
        category: CategoryModel.fromCollection(category),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CategoryModel> getCategoryByName(String name) async {
    try {
      final category =
          await _isar.categorys.filter().categoryNameEqualTo(name).findFirst();

      if (category == null) {
        return Future.error("Category not found");
      }
      return CategoryModel.fromCollection(category);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RoutineModel>> getAllRoutine() async {
    try {
      final allRoutine = await _isar.routines.where().findAll();
      return allRoutine
          .map(
            (e) => RoutineModel(
              id: e.id,
              title: e.title,
              startTime: e.startTime,
              day: e.day,
              category: CategoryModel.fromCollection(e.category.value!),
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RoutineModel>> getRoutineByCategories(
      List<String> categoryNames) async {
    try {
      List<Category> categories = [];
      for (var categoryName in categoryNames) {
        var category = await _isar.categorys
            .filter()
            .categoryNameEqualTo(categoryName)
            .findFirst();
        if (category != null) {
          categories.add(category);
        }
      }

      final categoryIds = categories.map((category) => category.id).toList();

      final routines = await _isar.routines
          .filter()
          .category(
            (q) => q.anyOf(
              categoryIds,
              (q, id) => q.idEqualTo(id),
            ),
          )
          .findAll();

      return routines
          .map(
            (routine) => RoutineModel(
              id: routine.id,
              title: routine.title,
              startTime: routine.startTime,
              day: routine.day,
              category: CategoryModel.fromCollection(routine.category.value!),
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoutineModel> editRoutine(RoutineModel routine) async {
    try {
      final category = Category()
        ..id = routine.category.id
        ..categoryName = routine.category.categoryName;

      final newRoutine = Routine()
        ..id = routine.id
        ..title = routine.title
        ..startTime = routine.startTime
        ..day = routine.day
        ..category.value = category;

      await _isar.writeTxn(() async {
        await _isar.routines.put(newRoutine);
        await _isar.categorys.put(category);
        await newRoutine.category.save();
      });

      return RoutineModel(
        id: newRoutine.id,
        title: newRoutine.title,
        startTime: newRoutine.startTime,
        day: newRoutine.day,
        category: CategoryModel.fromCollection(category),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteRoutine(int routineId) async {
    try {
      await _isar.writeTxn(() async {
        // Menghapus rutin dengan ID yang diberikan
        bool success = await _isar.routines.delete(routineId);

        // Jika penghapusan tidak berhasil, lempar pengecualian
        if (!success) {
          throw Exception('Failed to delete routine with ID $routineId');
        }
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
