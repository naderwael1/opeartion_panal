import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? employeeFirstName;
  String? employeeLastName;
  String? employeeRole;
  String? employeeStatus;
  String? employeePosition;
  String? employeeBranchName;
  String? sectionName;
  String? picturePath;
  String? employeeBranchId;
  String? branchSectionId;
  String? employeeId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeFirstName = _capitalize(prefs.getString('employee_first_name') ?? 'N/A');
      employeeLastName = _capitalize(prefs.getString('employee_last_name') ?? 'N/A');
      employeeRole = _capitalize(prefs.getString('employee_role') ?? 'N/A');
      employeeStatus = _capitalize(prefs.getString('employee_status') ?? 'N/A');
      employeePosition = _capitalize(prefs.getString('employee_position') ?? 'N/A');
      employeeBranchName = _capitalize(prefs.getString('employee_branch_name') ?? 'N/A');
      sectionName = _capitalize(prefs.getString('section_name') ?? 'N/A');
      picturePath = prefs.getString('picture_path') ?? 'N/A'; // Assuming this is a path and should not be capitalized

      employeeBranchId = _handleIntValue(prefs.getInt('employee_branch_id'));
      branchSectionId = _handleIntValue(prefs.getInt('branch_section_id'));
      employeeId = _handleIntValue(prefs.getInt('employee_id'));
    });
  }

  String _handleIntValue(int? value) {
    if (value == null || value == 0) {
      return 'N/A';
    } else {
      return value.toString();
    }
  }

  String? _capitalize(String? input) {
    if (input == null || input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Employee ID: ${employeeId ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('First Name: ${employeeFirstName ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Last Name: ${employeeLastName ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Role: ${employeeRole ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Status: ${employeeStatus ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Position: ${employeePosition ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Branch Name: ${employeeBranchName ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Branch ID: ${employeeBranchId ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Branch Section ID: ${branchSectionId ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Section Name: ${sectionName ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            //Text('Picture Path: ${picturePath ?? 'N/A'}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
