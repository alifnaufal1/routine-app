import 'package:fpdart/fpdart.dart';
import 'package:todolist_app/core/errors/failure.dart';

abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
