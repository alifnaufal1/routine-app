import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/entities/category_entity.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';

class CreateCategoryUseCase
    implements UseCase<CategoryEntity, CreateCategoryParams> {
  final RoutineRepository _repository;
  CreateCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(
      CreateCategoryParams params) async {
    return await _repository.createCategory(params.category);
  }
}

class CreateCategoryParams {
  final String category;
  CreateCategoryParams(this.category);
}
