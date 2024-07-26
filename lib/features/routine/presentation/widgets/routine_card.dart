import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/core/theme/app_pallete.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';
import 'package:todolist_app/features/routine/presentation/bloc/routine_bloc.dart';
import 'package:todolist_app/features/routine/presentation/pages/detail_routine_page.dart';

class RoutineCard extends StatelessWidget {
  final RoutineEntity routine;
  final List<String> selectedCategory;
  final Color color;
  const RoutineCard({
    super.key,
    required this.routine,
    required this.selectedCategory,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          DetailRoutinePage.route(routine),
        ).then(
          (_) {
            context.read<RoutineBloc>().add(
                  RoutineFetchedByCategories(
                    selectedCategory,
                  ),
                );
          },
        );
      },
      child: Card(
        color: color,
        child: ListTile(
          title: Text(
            routine.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          titleTextStyle: const TextStyle(fontSize: 25),
          subtitle: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: AppPallete.whiteColor,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "${routine.startTime.hour.toString()}:${routine.startTime.minute.toString().padLeft(2, '0')} ${routine.startTime.period.name.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppPallete.whiteColor,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_sharp,
                      color: AppPallete.whiteColor,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      routine.day,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppPallete.whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
