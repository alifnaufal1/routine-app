import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';

class GetRoutineByCategoriesUseCase
    implements UseCase<List<RoutineEntity>, GetRoutineByCategoriesParams> {
  final RoutineRepository _repository;
  GetRoutineByCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<RoutineEntity>>> call(
    GetRoutineByCategoriesParams params,
  ) async {
    return await _repository.getRoutineByCategories(params.categoryNames);
  }
}

class GetRoutineByCategoriesParams {
  final List<String> categoryNames;
  GetRoutineByCategoriesParams(this.categoryNames);
}
