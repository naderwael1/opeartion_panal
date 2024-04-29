import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/branch_model.dart'; // Update the path as needed
import '../Data/get_emp_atns.dart'; // Update the path as needed
import '../models/employeesAttendance_model.dart'; // Update the path as needed
import '../presentation/custom_attendance_card.dart'; // Update the path as needed

// Define BranchModel correctly as per your JSON response structure

class GetAllBranches {
  Future<List<BranchModel>> getAllBranches() async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/branch/branches-list'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        List<dynamic> branchData = jsonResponse['data'];
        return branchData.map((data) => BranchModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load branches data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}

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
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

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
              title: const Text('Select Branch'),
              subtitle: DropdownButton<BranchModel>(
                value: selectedBranch,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                onChanged: (BranchModel? newValue) {
                  setState(() {
                    selectedBranch = newValue;
                    branchId = newValue?.branchID;
                  });
                },
                items: branches?.map((BranchModel branch) {
                  return DropdownMenuItem<BranchModel>(
                    value: branch,
                    child: Text(branch.branchName),
                  );
                }).toList(),
              ),
            ),
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
              onPressed:
                  fromDate != null && toDate != null && selectedBranch != null
                      ? () {
                          // Implement what happens when the button is pressed
                          // Possibly updating the state or fetching data
                        }
                      : null, // Disable button until all selections are made
              child: const Text('Load Attendance Data'),
            ),
            if (fromDate != null && toDate != null && selectedBranch != null)
              FutureBuilder<List<EmployeesAttendanceModel>>(
                future: GetEmpAtndance().getEmpAtndance(
                  branch_id: selectedBranch!.branchID.toString(),
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
