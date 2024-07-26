import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/core/common/widgets/loader.dart';
import 'package:todolist_app/core/theme/app_pallete.dart';
import 'package:todolist_app/features/routine/presentation/bloc/category_bloc.dart';
import 'package:todolist_app/features/routine/presentation/bloc/routine_bloc.dart';
import 'package:todolist_app/features/routine/presentation/pages/create_routine_page.dart';
import 'package:todolist_app/features/routine/presentation/widgets/routine_card.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _selectedCategory = [];

  @override
  void initState() {
    super.initState();
    context.read<RoutineBloc>().add(RoutineAllFetched());
    context.read<CategoryBloc>().add(CategoryAllFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routines"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CreateRoutinePage.route(),
              ).then(
                (_) {
                  context.read<RoutineBloc>().add(
                        RoutineFetchedByCategories(
                          _selectedCategory,
                        ),
                      );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryFetchAllSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8.0,
                        children: state.categories
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  final String category = e.categoryName;
                                  if (_selectedCategory.contains(category)) {
                                    _selectedCategory.remove(category);
                                  } else {
                                    _selectedCategory.add(category);
                                  }
                                  setState(() {});
                                  context.read<RoutineBloc>().add(
                                        RoutineFetchedByCategories(
                                          _selectedCategory,
                                        ),
                                      );
                                },
                                child: Chip(
                                  label: Text(e.categoryName),
                                  color:
                                      _selectedCategory.contains(e.categoryName)
                                          ? const MaterialStatePropertyAll(
                                              AppPallete.gradient1,
                                            )
                                          : null,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<RoutineBloc, RoutineState>(
                builder: (context, state) {
                  if (state is RoutineLoading) {
                    return const Loader();
                  } else if (state is RoutineFetchEmpty) {
                    return const Center(
                      child: Text("No Routines yet"),
                    );
                  } else if (state is RoutineFetchAllSuccess ||
                      state is RoutineFilteredSuccess) {
                    final routines = state is RoutineFetchAllSuccess
                        ? state.routines
                        : (state as RoutineFilteredSuccess).filteredRoutines;
                    return ListView.builder(
                      itemCount: routines.length,
                      itemBuilder: (context, index) {
                        final routine = routines[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoutineCard(
                            routine: routine,
                            selectedCategory: _selectedCategory,
                            color: index % 3 == 0
                                ? AppPallete.gradient1
                                : index % 3 == 1
                                    ? AppPallete.gradient2
                                    : AppPallete.gradient3,
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
