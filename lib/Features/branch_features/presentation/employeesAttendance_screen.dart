import 'package:bloc_v2/Features/branch_features/Data/get_all_branchs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/branch_model.dart'; // Update the path as needed
import '../Data/get_emp_atns.dart'; // Update the path as needed
import '../models/employeesAttendance_model.dart'; // Update the path as needed

class EmpAttendanceScreen extends StatefulWidget {
  const EmpAttendanceScreen({Key? key}) : super(key: key);

  @override
  _EmpAttendanceScreenState createState() => _EmpAttendanceScreenState();
}

class _EmpAttendanceScreenState extends State<EmpAttendanceScreen> {
  int? branchId = 2;
  DateTime? fromDate;
  DateTime? toDate;
  List<BranchModel>? branches;
  BranchModel? selectedBranch;
  List<EmployeesAttendanceModel>?
      attendanceData; // State variable to hold attendance data

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    try {
      branches = await GetAllBranches().getAllBranches();
      setState(() {
        selectedBranch = branches?.firstWhere((b) => b.branchID == branchId,
            orElse: () => branches!.first);
      });
    } catch (e) {
      print('Failed to fetch branches: $e');
    }
  }

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

  void loadData() async {
    if (selectedBranch != null && fromDate != null && toDate != null) {
      try {
        var fetchedData = await GetEmpAtndance().getEmpAtndance(
          branch_id: selectedBranch!.branchID.toString(),
          fromDate: fromDate!,
          toDate: toDate!,
        );
        setState(() {
          attendanceData = fetchedData;
        });
        print('Data loaded: $attendanceData');
      } catch (e) {
        print('Failed to load data: $e');
      }
    }
  }

  Widget buildDropDownButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<BranchModel>(
        value: selectedBranch,
        icon: const Icon(Icons.arrow_downward, color: Colors.deepPurple),
        style: GoogleFonts.lato(color: Colors.deepPurple, fontSize: 16),
        onChanged: (BranchModel? newValue) {
          setState(() {
            selectedBranch = newValue;
            branchId = newValue?.branchID;
          });
        },
        items:
            branches?.map<DropdownMenuItem<BranchModel>>((BranchModel branch) {
          return DropdownMenuItem<BranchModel>(
            value: branch,
            child: Text(branch.branchName),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Attendance', style: GoogleFonts.openSans()),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Select Branch',
                  style: TextStyle(color: Colors.deepPurple)),
              subtitle: buildDropDownButton(),
            ),
            DatePickerTile(
                label: 'Select From Date',
                date: fromDate,
                onSelectDate: _selectFromDate),
            DatePickerTile(
                label: 'Select To Date',
                date: toDate,
                onSelectDate: _selectToDate),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed:
                    fromDate != null && toDate != null && selectedBranch != null
                        ? loadData
                        : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple),
                child: const Text('Load Attendance Data'),
              ),
            ),
            if (attendanceData != null)
              ListView.builder(
                shrinkWrap:
                    true, // Important to prevent scrolling within scrolling
                itemCount: attendanceData!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(attendanceData![index]
                        .employee), // Assuming 'employeeName' is a field in your model
                    subtitle: Text(
                        'Attendance details here...'), // Add more details as necessary
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final Future<void> Function(BuildContext) onSelectDate;

  const DatePickerTile({
    required this.label,
    this.date,
    required this.onSelectDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.deepPurple)),
      subtitle: Text(
        date == null ? 'Not set' : DateFormat('yyyy-MM-dd').format(date!),
        style: GoogleFonts.lato(color: Colors.black54, fontSize: 16),
      ),
      onTap: () => onSelectDate(context),
    );
  }
}
