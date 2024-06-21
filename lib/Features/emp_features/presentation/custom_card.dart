import 'package:bloc_v2/Features/emp_features/presentation/ShowAllDataAboutEmployee_scren.dart';
import 'package:bloc_v2/Features/emp_features/presentation/edit_change_status_model.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_data_employee_screen.dart';
import 'package:bloc_v2/Features/emp_features/models/active_emp_model.dart';

class CustomCard extends StatelessWidget {
  final ActiveEmployeesModel activeEmployee;
  final Function startPolling; // Add this line

  const CustomCard({
    required this.activeEmployee,
    required this.startPolling, // Add this line
    Key? key,
  }) : super(key: key);

  String capitalize(String s) => s.isNotEmpty
      ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
      : '';

  @override
  Widget build(BuildContext context) {
    final nameParts = activeEmployee.employeeName.split(' ');
    final capitalizedEmployeeName = nameParts.map(capitalize).join(' ');

    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://tse3.mm.bing.net/th?id=OIP.CuBCc2R2knpvmVugLTBczAHaJU&pid=Api&P=0&h=220',
            ),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            capitalizedEmployeeName,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            activeEmployee.employeePosition,
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal.shade800,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowAllDataAboutEmployee(
                        employee: activeEmployee,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.remove_red_eye, color: Colors.teal.shade700),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEmployeeScreen(
                        employeeId: activeEmployee.employeeId,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Colors.teal.shade700),
              ),
              IconButton(
                onPressed: () {
                  _showDeleteDialog(context, activeEmployee.employeeId.toString());
                },
                icon: Icon(Icons.delete, color: Colors.teal.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Select Action',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            ),
          ),
          content: Text(
            'What do you want to do with this employee?',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.teal.shade800,
              ),
            ),
          ),
          backgroundColor: Colors.teal.shade100,
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  final newStatus = activeEmployee.employeeStatus == 'active'
                      ? 'inactive'
                      : 'active';
                  final addStorage_Model = await editChangeStatusModel(
                    employeeId: employeeId,
                    employeeStatus: newStatus,
                  );
                  print('Adding Storage: $addStorage_Model');
                  CherryToast.success(
                    animationType: AnimationType.fromRight,
                    toastPosition: Position.bottom,
                    description: const Text(
                      "Edit Status successfully",
                      style: TextStyle(color: Colors.black),
                    ),
                  ).show(context);
                  Navigator.of(context).pop();
                  startPolling(); // Call startPolling here
                } catch (e) {
                  print('Error add menu item: $e');
                  CherryToast.error(
                    toastPosition: Position.bottom,
                    animationType: AnimationType.fromRight,
                    description: const Text(
                      "Something went wrong!",
                      style: TextStyle(color: Colors.black),
                    ),
                  ).show(context);
                }
              },
              child: Text(
                activeEmployee.employeeStatus == 'active' ? 'Inactive' : 'Active',
                style: TextStyle(color: Colors.teal.shade700),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Canceled',
                style: TextStyle(color: Colors.teal.shade700),
              ),
            ),
          ],
        );
      },
    );
  }
}
