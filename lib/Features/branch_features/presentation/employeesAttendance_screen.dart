import 'package:flutter/material.dart';
import 'package:bloc_v2/Features/branch_features/Data/get_emp_atns.dart';
import 'package:bloc_v2/Features/branch_features/models/employeesAttendance_model.dart';
import 'package:bloc_v2/Features/branch_features/presentation/custom_attendance_card.dart';
import '../../../core/utils/theme.dart';
import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';
import '../Data/get_all_branchs.dart';

class EmpAttendanceScreen extends StatefulWidget {
  const EmpAttendanceScreen({Key? key}) : super(key: key);

  @override
  _EmpAttendanceScreenState createState() => _EmpAttendanceScreenState();
}

class _EmpAttendanceScreenState extends State<EmpAttendanceScreen> {
  int? branchId = 2;
  Future<List<BranchModel>>? branchesFuture;

  @override
  void initState() {
    super.initState();
    branchesFuture = GetAllBranches().getAllBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Attendance'),
        centerTitle: true,
        actions: const [
          ThemeToggleWidget(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<BranchModel>>(
              future: branchesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return DropdownButtonFormField<int>(
                    value: branchId,
                    onChanged: (int? newValue) {
                      setState(() {
                        branchId = newValue;
                      });
                    },
                    items: snapshot.data!.map((BranchModel branch) {
                      return DropdownMenuItem<int>(
                        value: branch.branchID,
                        child: Text(branch.branchName),
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('No branches available');
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<EmployeesAttendanceModel>>(
              future: GetEmpAtndance()
                  .getEmpAtndance(branch_id: branchId.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
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
          ),
        ],
      ),
    );
  }
}
