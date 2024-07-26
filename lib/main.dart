import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/core/theme/app_theme.dart';
import 'package:todolist_app/features/routine/presentation/bloc/category_bloc.dart';
import 'package:todolist_app/features/routine/presentation/bloc/routine_bloc.dart';
import 'package:todolist_app/features/routine/presentation/pages/home_page.dart';
import 'package:todolist_app/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<RoutineBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<CategoryBloc>(),
        )
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightThemeMode,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
