part of 'routine_bloc.dart';

@immutable
sealed class RoutineEvent {}

class RoutineCategoryCreated extends RoutineEvent {
  final String category;
  RoutineCategoryCreated(this.category);
}

class RoutineCategoriesFetched extends RoutineEvent {}

class RoutineNewCreated extends RoutineEvent {
  final String title;
  final TimeOfDay startTime;
  final String day;
  final String categoryName;

  RoutineNewCreated({
    required this.title,
    required this.startTime,
    required this.day,
    required this.categoryName,
  });
}

class RoutineAllFetched extends RoutineEvent {}

class RoutineFetchedByCategories extends RoutineEvent {
  final List<String> categoryNames;
  RoutineFetchedByCategories(this.categoryNames);
}

class RoutineUpdated extends RoutineEvent {
  final int id;
  final String title;
  final TimeOfDay startTime;
  final String day;
  final String categoryName;

  RoutineUpdated({
    required this.id,
    required this.title,
    required this.startTime,
    required this.day,
    required this.categoryName,
  });
}

class RoutineDeleted extends RoutineEvent {
  final int id;
  RoutineDeleted(this.id);
}
