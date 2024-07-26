part of 'routine_bloc.dart';

@immutable
sealed class RoutineState {
  const RoutineState();
}

class RoutineInitial extends RoutineState {}

class RoutineLoading extends RoutineState {}

class RoutineSuccess extends RoutineState {
  final String newCategory;
  const RoutineSuccess(this.newCategory);
}

class RoutineCreatedSuccess extends RoutineState {
  final String message;
  const RoutineCreatedSuccess(this.message);
}

class RoutineCategoriesFetchSuccess extends RoutineState {
  final List<CategoryEntity> categories;
  const RoutineCategoriesFetchSuccess(this.categories);
}

class RoutineFetchAllSuccess extends RoutineState {
  final List<RoutineEntity> routines;
  const RoutineFetchAllSuccess(this.routines);
}

class RoutineFilteredSuccess extends RoutineState {
  final List<RoutineEntity> filteredRoutines;
  const RoutineFilteredSuccess(this.filteredRoutines);
}

class RoutineFetchEmpty extends RoutineState {}

class RoutineUpdatedSuccess extends RoutineState {
  final String message;
  const RoutineUpdatedSuccess(this.message);
}

class RoutineDeletedSuccess extends RoutineState {}

class RoutineFailure extends RoutineState {
  final String error;
  const RoutineFailure(this.error);
}
