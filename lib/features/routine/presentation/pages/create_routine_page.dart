import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/core/constants/constants.dart';
import 'package:todolist_app/core/utils/format_time.dart';
import 'package:todolist_app/core/utils/show_snackbar.dart';
import 'package:todolist_app/features/routine/presentation/bloc/routine_bloc.dart';
import 'package:todolist_app/features/routine/presentation/pages/home_page.dart';
import 'package:todolist_app/features/routine/presentation/widgets/category_dropdown.dart';
import 'package:todolist_app/features/routine/presentation/widgets/routine_gradient_button.dart';
import 'package:todolist_app/features/routine/presentation/widgets/routine_text_box.dart';

class CreateRoutinePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateRoutinePage(),
      );
  const CreateRoutinePage({super.key});

  @override
  State<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends State<CreateRoutinePage> {
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
    const categories = Constants.categories;
    for (var category in categories) {
      _categoryItems.add(category);
    }
    context.read<RoutineBloc>().add(
          RoutineCategoriesFetched(),
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

  void _createRoutine() {
    if (_formKey.currentState!.validate()) {
      context.read<RoutineBloc>().add(
            RoutineNewCreated(
              title: _titleController.text.trim(),
              startTime: _selectedTime!,
              day: _selectedDay!,
              categoryName: _selectedCategory!,
            ),
          );
    }
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
        title: const Text("Create Routine"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocListener<RoutineBloc, RoutineState>(
        listener: (context, state) {
          if (state is RoutineFailure) {
            showSnackBar(context, "Fail to create routine! ${state.error}");
          } else if (state is RoutineCreatedSuccess) {
            showSnackBar(context, state.message);
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
                        child: BlocBuilder<RoutineBloc, RoutineState>(
                          builder: (context, state) {
                            if (state is RoutineCategoriesFetchSuccess) {
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
                    buttonText: "Add Routine",
                    onPressed: _createRoutine,
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
