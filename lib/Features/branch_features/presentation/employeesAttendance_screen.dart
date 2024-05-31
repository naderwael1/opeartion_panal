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
  DateTimeRange? selectedDateRange;
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

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      setState(() {
        selectedDateRange = result;
      });
    }
  }

  void loadData() async {
    if (selectedBranch != null && selectedDateRange != null) {
      try {
        var fetchedData = await GetEmpAtndance().getEmpAtndance(
          branch_id: selectedBranch!.branchID.toString(),
          fromDate: selectedDateRange!.start,
          toDate: selectedDateRange!.end,
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
        icon: const Icon(Icons.arrow_downward, color: Colors.blueGrey),
        style: GoogleFonts.lato(color: Colors.blueGrey, fontSize: 16),
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
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueGrey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                title: const Text('Select Branch',
                    style: TextStyle(color: Colors.blueGrey)),
                subtitle: buildDropDownButton(),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                title: const Text('Select Date Range',
                    style: TextStyle(color: Colors.blueGrey)),
                subtitle: selectedDateRange == null
                    ? const Text('No date range selected',
                        style: TextStyle(color: Colors.black54))
                    : Text(
                        'From: ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)}\nTo: ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                onTap: () => _selectDateRange(context),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedDateRange != null && selectedBranch != null
                  ? loadData
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              child: const Text('Load Attendance Data',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (attendanceData != null)
              Expanded(
                child: ListView.builder(
                  itemCount: attendanceData!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(attendanceData![index]
                            .employee), // Assuming 'employeeName' is a field in your model
                        subtitle: const Text(
                            'Attendance details here...'), // Add more details as necessary
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
