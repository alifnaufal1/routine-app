import 'package:flutter/material.dart';

class ItemDropdown extends StatelessWidget {
  final List<String> items;
  final String labelText;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  const ItemDropdown({
    super.key,
    required this.items,
    required this.labelText,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      value: selectedItem,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Select $labelText',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$labelText is missing!";
        }
        return null;
      },
    );
  }
}
