import 'package:bloc_v2/Features/branch_features/Data/get_emp_atns.dart';
import 'package:bloc_v2/Features/branch_features/models/employeesAttendance_model.dart';
import 'package:bloc_v2/Features/branch_features/presentation/custom_attendance_card.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/theme.dart';

import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';
import '../../../Drawer/customDrawer.dart';
import '../Data/get_all_branchs.dart';

import 'add_branch_screen.dart';
import 'custom_branch_card.dart';

class EmpAttendanceScreen extends StatelessWidget {
  const EmpAttendanceScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Attendance'),
        centerTitle: true,
        actions: [
          const ThemeToggleWidget(), // Add the ThemeToggleWidget here
        ],
      ),
      body: FutureBuilder<List<EmployeesAttendanceModel>>(
        future:
            GetEmpAtndance().getEmpAtndance(branch_id: '2'), //branch_id: '1'
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<EmployeesAttendanceModel> employees =
                snapshot.data!.cast<EmployeesAttendanceModel>();
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return CustomAattendanceCard(employeeA: employees[index]);
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
