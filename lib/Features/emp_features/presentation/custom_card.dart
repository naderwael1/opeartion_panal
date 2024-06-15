import 'package:bloc_v2/Features/emp_features/Data/udage_employee.dart';
import 'package:bloc_v2/Features/emp_features/models/active_emp_model.dart';
import 'update_employee.dart';

import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final ActiveEmployeesModel activeEmployee;
// Assume EmployeeModel is defined elsewhere

  const CustomCard({
    required this.activeEmployee,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://tse3.mm.bing.net/th?id=OIP.CuBCc2R2knpvmVugLTBczAHaJU&pid=Api&P=0&h=220',
          ), // Your employee's image URL
          backgroundColor: Colors.transparent,
        ),
        title: Text(activeEmployee.employeeName), // Your employee's name
        subtitle: Text(activeEmployee.employeePosition),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                // Action for this button
              },
              icon: const Icon(Icons.remove_red_eye),
            ),
            IconButton(
              onPressed: () {
                // Action for this button
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                // Action for this button
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
