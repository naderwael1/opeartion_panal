import 'package:flutter/material.dart';

Widget buildDropdownMenu(String label, String? value, List<String> items, void Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.event_available),
    ),
    value: value,
    items: items
        .map<DropdownMenuItem<String>>((String itemValue) {
      return DropdownMenuItem<String>(
        value: itemValue,
        child: Text(itemValue),
      );
    }).toList(),
    onChanged: onChanged,
  );
}
