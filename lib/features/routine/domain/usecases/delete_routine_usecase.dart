import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';

class DeleteRoutineUsecase implements UseCase<void, DeleteRoutineParams> {
  final RoutineRepository _repository;
  DeleteRoutineUsecase(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteRoutineParams params) async {
    return await _repository.deleteRoutine(params.routineId);
  }
}

class DeleteRoutineParams {
  final int routineId;
  DeleteRoutineParams(this.routineId);
}
