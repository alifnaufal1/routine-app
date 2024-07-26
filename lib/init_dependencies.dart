import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist_app/features/routine/data/collections/category.dart';
import 'package:todolist_app/features/routine/data/collections/routine.dart';
import 'package:todolist_app/features/routine/data/datasources/routine_isar_data_source.dart';
import 'package:todolist_app/features/routine/data/repositories/routine_repository_impl.dart';
import 'package:todolist_app/features/routine/domain/repositories/routine_repository.dart';
import 'package:todolist_app/features/routine/domain/usecases/create_category_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/create_routine_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/delete_routine_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/edit_routine_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/get_all_category_usecase.dart';
import 'package:todolist_app/features/routine/domain/usecases/get_all_routine_usecas.dart';
import 'package:todolist_app/features/routine/domain/usecases/get_routine_by_categories_usecase.dart';
import 'package:todolist_app/features/routine/presentation/bloc/category_bloc.dart';
import 'package:todolist_app/features/routine/presentation/bloc/routine_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initRoutine();
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open(
    directory: dir.path,
    [CategorySchema, RoutineSchema],
  );

  sl.registerLazySingleton(() => isar);
}

void _initRoutine() {
  sl
    // DataSource
    ..registerFactory<RoutineIsarDataSource>(
      () => RoutineIsarDataSourceImpl(
        sl(),
      ),
    )
    // Repository
    ..registerFactory<RoutineRepository>(
      () => RoutineRepositoryImpl(
        sl(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => CreateCategoryUseCase(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetAllCategoryUseCase(
        sl(),
      ),
    )
    ..registerFactory(
      () => CreateRoutineUseCase(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetAllRoutineUseCase(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetRoutineByCategoriesUseCase(
        sl(),
      ),
    )
    ..registerFactory(
      () => EditRoutineUseCase(
        sl(),
      ),
    )..registerFactory(() => DeleteRoutineUsecase(sl(),),)
    // Bloc
    ..registerLazySingleton(
      () => RoutineBloc(
        createCategory: sl(),
        getAllCategory: sl(),
        createRoutine: sl(),
        getAllRoutine: sl(),
        getRoutineByCategories: sl(),
        editRoutine: sl(),
        deleteRoutine: sl(),
      ),
    )
    ..registerLazySingleton(
      () => CategoryBloc(
        getAllCategory: sl(),
      ),
    );
}
