import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/core/usecase/usecase.dart';
import 'package:todolist_app/features/routine/domain/entities/category_entity.dart';
import 'package:todolist_app/features/routine/domain/usecases/get_all_category_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoryUseCase _getAllCategory;

  CategoryBloc({required GetAllCategoryUseCase getAllCategory,}) : _getAllCategory = getAllCategory, super(CategoryInitial()) {
    on<CategoryAllFetched>(_onFetchCategories);
  }

  void _onFetchCategories(
    CategoryAllFetched event,
    Emitter<CategoryState> emit,
  ) async {
    final response = await _getAllCategory(NoParams());

    response.fold(
      (failure) => emit(CategoryFailure(failure.message)),
      (categories) => emit(CategoryFetchAllSuccess(categories)),
    );
  }
}
