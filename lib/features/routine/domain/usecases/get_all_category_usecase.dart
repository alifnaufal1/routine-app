import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/entities/category_entity.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';

class GetAllCategoryUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final RoutineRepository _repository;
  GetAllCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await _repository.getAllCategory();
  }
}
