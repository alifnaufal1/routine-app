part of 'category_bloc.dart';

@immutable
sealed class CategoryState {
  const CategoryState();
}

final class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryFetchAllSuccess extends CategoryState {
  final List<CategoryEntity> categories;
  const CategoryFetchAllSuccess(this.categories);
}

class CategoryFailure extends CategoryState {
  final String error;
  const CategoryFailure(this.error);
}
