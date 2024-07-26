import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';

class GetAllRoutineUseCase implements UseCase<List<RoutineEntity>, NoParams> {
  final RoutineRepository _repository;
  GetAllRoutineUseCase(this._repository);

  @override
  Future<Either<Failure, List<RoutineEntity>>> call(NoParams params) async {
    return await _repository.getAllRoutine();
  }
}
