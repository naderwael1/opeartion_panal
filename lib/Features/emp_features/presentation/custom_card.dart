import 'package:bloc_v2/Features/emp_features/Data/udage_employee.dart';
import 'update_employee.dart';

import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final EmployeeModel employee; // Assume EmployeeModel is defined elsewhere

  const CustomCard({
    required this.employee,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              NetworkImage(employee.image), // Your employee's image URL
          backgroundColor: Colors.transparent,
        ),
        title: Text(employee.category), // Your employee's name
        subtitle: Text(employee.title), // Your employee's position
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                // Action for this button
              },
              icon: Icon(Icons.remove_red_eye),
            ),
            IconButton(
              onPressed: () {
                // Action for this button
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                // Action for this button
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
