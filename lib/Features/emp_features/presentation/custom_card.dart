import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_data_employee_screen.dart';
import 'package:bloc_v2/Features/emp_features/models/active_emp_model.dart';

class CustomCard extends StatelessWidget {
  final ActiveEmployeesModel activeEmployee;

  const CustomCard({
    required this.activeEmployee,
    Key? key,
  }) : super(key: key);

  String capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}' : '';

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
            colors: [Colors.blueGrey.shade100, Colors.blueGrey.shade300],
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
                color: Colors.blueGrey.shade900,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            activeEmployee.employeePosition,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey.shade800,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  // Action for this button
                },
                icon: Icon(Icons.remove_red_eye, color: Colors.blueGrey.shade700),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEmployeeScreen(employeeId: activeEmployee.employeeId),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Colors.blueGrey.shade700),
              ),
              IconButton(
                onPressed: () {
                  // Action for this button
                },
                icon: Icon(Icons.delete, color: Colors.blueGrey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
