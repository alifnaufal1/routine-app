import 'package:todolist_app/features/routine/data/collections/category.dart';
import 'package:todolist_app/features/routine/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.categoryName,
  });

  factory CategoryModel.fromCollection(Category data) {
    return CategoryModel(
      id: data.id,
      categoryName: data.categoryName,
    );
  }

  
}
