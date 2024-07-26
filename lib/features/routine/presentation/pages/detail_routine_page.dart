import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/core/constants/constants.dart';
import 'package:todolist_app/core/utils/format_time.dart';
import 'package:todolist_app/core/utils/show_snackbar.dart';
import 'package:todolist_app/features/routine/domain/entities/routine_entity.dart';
import 'package:todolist_app/features/routine/presentation/bloc/category_bloc.dart';
import 'package:todolist_app/features/routine/presentation/bloc/routine_bloc.dart';
import 'package:todolist_app/features/routine/presentation/pages/home_page.dart';
import 'package:todolist_app/features/routine/presentation/widgets/category_dropdown.dart';
import 'package:todolist_app/features/routine/presentation/widgets/routine_gradient_button.dart';
import 'package:todolist_app/features/routine/presentation/widgets/routine_text_box.dart';

class DetailRoutinePage extends StatefulWidget {
  static route(RoutineEntity routine) => MaterialPageRoute(
        builder: (context) => DetailRoutinePage(
          routine: routine,
        ),
      );
  final RoutineEntity routine;
  const DetailRoutinePage({
    super.key,
    required this.routine,
  });

  @override
  State<DetailRoutinePage> createState() => _DetailRoutinePageState();
}

class _DetailRoutinePageState extends State<DetailRoutinePage> {
  final _formKey = GlobalKey<FormState>();
  final _newCategoryController = TextEditingController();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  String? _selectedCategory;
  String? _selectedDay;
  final Set<String> _categoryItems = {};

  @override
  void initState() {
    super.initState();
    final routine = widget.routine;
    const categories = Constants.categories;
    for (var i = 0; i < categories.length; i++) {
      _categoryItems.add(categories[i]);
    }
    _titleController.text = routine.title;
    _selectedTime = TimeOfDay(
      hour: routine.startTime.hour,
      minute: routine.startTime.minute,
    );
    _timeController.text = formatStartTime(_selectedTime!);
    _selectedCategory = routine.category.categoryName;
    _selectedDay = routine.day;

    context.read<CategoryBloc>().add(
          CategoryAllFetched(),
        );
  }

  void _pickStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime!,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null) {
      _selectedTime = timeOfDay;
      setState(
        () {
          _timeController.text = formatStartTime(_selectedTime!);
        },
      );
    }
  }

  void _createCategory(String newCategory) {
    if (!_categoryItems.contains(newCategory)) {
      _categoryItems.add(newCategory);
      Navigator.pop(context);
    } else {
      showSnackBar(context, "Category already exist!");
    }
  }

  void _updateRoutine() {
    if (_formKey.currentState!.validate()) {
      context.read<RoutineBloc>().add(
            RoutineUpdated(
              id: widget.routine.id,
              title: _titleController.text.trim(),
              startTime: _selectedTime!,
              day: _selectedDay!,
              categoryName: _selectedCategory!,
            ),
          );
    }
  }

  void _deleteDialog() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text(
        "Sure want to delete?",
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        RoutineGradientButton(
          buttonText: "DELETE",
          onPressed: () {
            _deleteRoutine();
            Navigator.pop(context);
          },
        ),
        RoutineGradientButton(
          buttonText: "CANCEL",
          onPressed: () {
            // _deleteRoutine();
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  void _deleteRoutine() {
    context.read<RoutineBloc>().add(
          RoutineDeleted(widget.routine.id),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _newCategoryController.dispose();
    _timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _deleteDialog();
            },
            icon: const Icon(
              Icons.delete_forever_rounded,
            ),
          ),
        ],
      ),
      body: BlocListener<RoutineBloc, RoutineState>(
        listener: (context, state) {
          if (state is RoutineFailure) {
            showSnackBar(context, "Fail to create routine! ${state.error}");
          } else if (state is RoutineUpdatedSuccess) {
            showSnackBar(context, state.message);
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (route) => false,
            );
          } else if (state is RoutineDeletedSuccess) {
            showSnackBar(context, "Success to delete");
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (route) => false,
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            if (state is CategoryFetchAllSuccess) {
                              _categoryItems.addAll(
                                state.categories
                                    .map(
                                      (e) => e.categoryName,
                                    )
                                    .toSet(),
                              );
                            }
                            return ItemDropdown(
                              labelText: "Category",
                              items: _categoryItems.toList(),
                              selectedItem: _selectedCategory,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Add New Category"),
                              content: RoutineTextBox(
                                controller: _newCategoryController,
                                hintText: "New Category",
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_newCategoryController
                                        .text.isNotEmpty) {
                                      _createCategory(
                                        _newCategoryController.text,
                                      );
                                    }
                                  },
                                  child: const Text("Add"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RoutineTextBox(
                    controller: _titleController,
                    hintText: "Title",
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: RoutineTextBox(
                          controller: _timeController,
                          isEnabled: false,
                          hintText: "Start Time",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _pickStartTime(context);
                        },
                        icon: const Icon(Icons.timer),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ItemDropdown(
                    items: Constants.days,
                    labelText: "Day",
                    selectedItem: _selectedDay,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDay = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 50),
                  RoutineGradientButton(
                    buttonText: "Update Routine",
                    onPressed: _updateRoutine,
                    fixedSize: const Size(395, 55),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
