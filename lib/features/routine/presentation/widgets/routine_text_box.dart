import 'package:flutter/material.dart';

class RoutineTextBox extends StatelessWidget {
  late TextEditingController _controller;
  late String _hintText;
  late bool _isEnabled;

  RoutineTextBox({
    super.key,
    required TextEditingController controller,
    required String hintText,
    bool isEnabled = true,
  }) {
    _controller = controller;
    _hintText = hintText;
    _isEnabled = isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: _isEnabled,
      decoration: InputDecoration(
        label: Text(_hintText),
      ),
      validator: (value) {
        if (value!.isEmpty && value != "New Category") {
          return "$_hintText is missing";
        } else {
          return null;
        }
      },
    );
  }
}
