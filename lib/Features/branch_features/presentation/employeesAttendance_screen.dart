import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../Data/get_emp_atns.dart'; // Ensure correct path
import '../models/employeesAttendance_model.dart'; // Ensure correct path
import '../presentation/custom_attendance_card.dart'; // Ensure correct path
import '../../../core/utils/theme.dart'; // Ensure correct path

class EmpAttendanceScreen extends StatefulWidget {
  const EmpAttendanceScreen({Key? key}) : super(key: key);

  @override
  _EmpAttendanceScreenState createState() => _EmpAttendanceScreenState();
}

class _EmpAttendanceScreenState extends State<EmpAttendanceScreen> {
  int? branchId = 2; // Default branchId to 2
  DateTime? fromDate;
  DateTime? toDate;
  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // For formatting dates

  // Function to show DatePicker and set fromDate
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  // Function to show DatePicker and set toDate
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Attendance'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Select From Date'),
              subtitle: Text(
                  fromDate == null ? 'Not set' : formatter.format(fromDate!)),
              onTap: () => _selectFromDate(context),
            ),
            ListTile(
              title: const Text('Select To Date'),
              subtitle:
                  Text(toDate == null ? 'Not set' : formatter.format(toDate!)),
              onTap: () => _selectToDate(context),
            ),
            ElevatedButton(
              onPressed: fromDate != null && toDate != null
                  ? () {
                      // Update your application state or perform actions when both dates are selected
                    }
                  : null, // Button is disabled until both dates are selected
              child: Text('Load Attendance Data'),
            ),
            if (fromDate != null &&
                toDate != null) // Only build FutureBuilder if dates are set
              FutureBuilder<List<EmployeesAttendanceModel>>(
                future: GetEmpAtndance().getEmpAtndance(
                  branch_id: branchId.toString(),
                  fromDate: fromDate!,
                  toDate: toDate!,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CustomAattendanceCard(
                            employeeA: snapshot.data![index]);
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
