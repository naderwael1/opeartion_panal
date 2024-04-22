import 'package:bloc_v2/Features/emp_features/Data/udage_employee.dart';
import 'update_employee.dart';

import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/active_emp_model.dart';

class CustomActiveCard extends StatelessWidget {
  CustomActiveCard({
    required this.activeEmployee,
    super.key,
  });
  ActiveEmployeesModel activeEmployee;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 45),
                  Center(
                    child: Text(
                      activeEmployee.employeeName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(employee.title.substring(0,5)),
                      Text(
                        activeEmployee.employeeBranch,
                      ), //ؤقمين يس
                      //Text(employee.price.toString()),
                      IconButton(
                        onPressed: () {
                          Get.to(() => UpdateEmployeeScreen(),
                              arguments:
                                  activeEmployee); // Corrected the builder
                        },
                        icon: Icon(Icons.account_box_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
