import 'package:bloc_v2/Features/emp_features/presentation/ShowAllDataAboutEmployee_scren.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_data_employee_screen.dart';
import 'package:bloc_v2/Features/emp_features/models/active_emp_model.dart';

class CustomCard extends StatelessWidget {
  final ActiveEmployeesModel activeEmployee;
  final Function startPolling;

  const CustomCard({
    Key? key,
    required this.activeEmployee,
    required this.startPolling,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final capitalizedEmployeeName = _capitalize(activeEmployee.employeeName);
    final capitalizedPosition = _capitalize(activeEmployee.employeePosition);

    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: activeEmployee.employeeStatus.toLowerCase() == 'active'
              ? Colors.green
              : Colors.red,
          width: 2.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 57, 133, 127),
              Color.fromARGB(255, 86, 91, 90)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: activeEmployee.employeeBranch.isNotEmpty
                  ? NetworkImage(activeEmployee.employeeBranch)
                  : null,
              child: activeEmployee.employeeBranch.isEmpty
                  ? Icon(Icons.person, size: 30, color: Colors.teal.shade700)
                  : null,
            ),
            title: Text(
              capitalizedEmployeeName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 164, 223, 213),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    capitalizedPosition,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 210, 230, 228),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _iconButton(context, Icons.remove_red_eye,
                    Color.fromARGB(255, 228, 234, 233), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShowAllDataAboutEmployee(employee: activeEmployee),
                    ),
                  );
                }),
                _iconButton(
                    context, Icons.edit, Color.fromARGB(255, 228, 234, 233),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEmployeeScreen(
                          employeeId: activeEmployee.employeeId),
                    ),
                  );
                }),
                _iconButton(context, Icons.delete, Colors.red, () {
                  // Specific red color for delete icon
                  _showDeleteDialog(
                      context, activeEmployee.employeeId.toString());
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon, Color iconColor,
      VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
    );
  }

  void _showDeleteDialog(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Select Action',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Text('What do you want to do with this employee?',
              style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.teal.shade100,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Implementation remains the same as previously provided
              },
              child: Text(
                  activeEmployee.employeeStatus == 'active'
                      ? 'Inactive'
                      : 'Active',
                  style: TextStyle(color: Colors.teal.shade700)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Canceled',
                  style: TextStyle(color: Colors.teal.shade700)),
            ),
          ],
        );
      },
    );
  }

  String _capitalize(String s) => s.isNotEmpty
      ? s
          .split(' ')
          .map((word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
          .join(' ')
      : '';
}
