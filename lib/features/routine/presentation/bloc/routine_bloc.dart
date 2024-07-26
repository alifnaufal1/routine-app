import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/entities/category_entity.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';
import 'package:todolist_app/features/routine/domain/usecases/create_category_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/create_routine_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/delete_routine_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/edit_routine_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/get_all_category_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/get_all_routine_usecas.dart';
import 'package:todolist_app/features/routine/domain/usecases/get_routine_by_categories_usecase.dart';

part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final CreateCategoryUseCase _createCategory;
  final GetAllCategoryUseCase _getAllCategory;
  final CreateRoutineUseCase _createRoutine;
  final GetAllRoutineUseCase _getAllRoutine;
  final GetRoutineByCategoriesUseCase _getRoutineByCategories;
  final EditRoutineUseCase _editRoutine;
  final DeleteRoutineUsecase _deleteRoutine;
  RoutineBloc({
    required CreateCategoryUseCase createCategory,
    required GetAllCategoryUseCase getAllCategory,
    required CreateRoutineUseCase createRoutine,
    required GetAllRoutineUseCase getAllRoutine,
    required GetRoutineByCategoriesUseCase getRoutineByCategories,
    required EditRoutineUseCase editRoutine,
    required DeleteRoutineUsecase deleteRoutine,
  })  : _createCategory = createCategory,
        _getAllCategory = getAllCategory,
        _createRoutine = createRoutine,
        _getAllRoutine = getAllRoutine,
        _getRoutineByCategories = getRoutineByCategories,
        _editRoutine = editRoutine,
        _deleteRoutine = deleteRoutine,
        super(RoutineInitial()) {
    on<RoutineEvent>((event, emit) => emit(RoutineLoading()));
    on<RoutineCategoryCreated>(_onCreateCategory);
    on<RoutineCategoriesFetched>(_onFetchCategories);
    on<RoutineNewCreated>(_onCreateRoutine);
    on<RoutineAllFetched>(_onFetchRoutines);
    on<RoutineFetchedByCategories>(_onFetchRoutinesByCategories);
    on<RoutineUpdated>(_onUpdateRoutine);
    on<RoutineDeleted>(_onDeleteRoutine);
  }

  void _onCreateCategory(
    RoutineCategoryCreated event,
    Emitter<RoutineState> emit,
  ) async {
    final response = await _createCategory(
      CreateCategoryParams(event.category),
    );

    response.fold(
      (failure) => emit(RoutineFailure(failure.message)),
      (category) => emit(RoutineSuccess(category.categoryName)),
    );
  }

  void _onFetchCategories(
    RoutineCategoriesFetched event,
    Emitter<RoutineState> emit,
  ) async {
    final response = await _getAllCategory(NoParams());

    response.fold(
      (failure) => emit(RoutineFailure(failure.message)),
      (categories) => emit(RoutineCategoriesFetchSuccess(categories)),
    );
  }

  void _onCreateRoutine(
    RoutineNewCreated event,
    Emitter<RoutineState> emit,
  ) async {
    final response = await _createRoutine(
      CreateRoutineParams(
        title: event.title,
        startTime: event.startTime,
        day: event.day,
        categoryName: event.categoryName,
      ),
    );

    response.fold(
      (failure) => emit(RoutineFailure(failure.message)),
      (routine) =>
          emit(const RoutineCreatedSuccess("Success to create new routine!")),
    );
  }

  void _onFetchRoutines(
    RoutineAllFetched event,
    Emitter<RoutineState> emit,
  ) async {
    final response = await _getAllRoutine(NoParams());

    response.fold(
      (failure) => emit(RoutineFailure(failure.message)),
      (routines) {
        if (routines.isEmpty || routines == []) {
          emit(RoutineFetchEmpty());
        } else {
          emit(RoutineFetchAllSuccess(routines));
        }
      },
    );
  }

  void _onFetchRoutinesByCategories(
    RoutineFetchedByCategories event,
    Emitter<RoutineState> emit,
  ) async {
    final response = await _getRoutineByCategories(
      GetRoutineByCategoriesParams(event.categoryNames),
    );

    response.fold(
      (failure) => emit(RoutineFailure(failure.message)),
      (routines) {
        if (routines.isEmpty || routines == []) {
          emit(RoutineFetchEmpty());
        } else {
          emit(RoutineFilteredSuccess(routines));
        }
      },
    );
  }

  void _onUpdateRoutine(
    RoutineUpdated event,
    Emitter<RoutineState> emit,
  ) async {
    final response = await _editRoutine(
      EditRoutineParams(
        id: event.id,
        title: event.title,
        startTime: event.startTime,
        day: event.day,
        categoryName: event.categoryName,
      ),
    );

    response.fold(
      (failure) => emit(RoutineFailure(failure.message)),
      (routine) =>
          emit(const RoutineUpdatedSuccess("Success to update the routine!")),
    );
  }

  void _onDeleteRoutine(
    RoutineDeleted event,
    Emitter<RoutineState> emit,
  ) async {
    final response = await _deleteRoutine(
      DeleteRoutineParams(event.id),
    );

    response.fold(
      (failure) => emit(RoutineFailure(failure.message)),
      (success) => emit(RoutineDeletedSuccess()),
    );
  }
}
