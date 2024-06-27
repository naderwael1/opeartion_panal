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
      picturePath = prefs.getString('picture_path') ?? 'N/A';

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
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: picturePath == null || picturePath == 'N/A' || !Uri.tryParse(picturePath!)!.isAbsolute
                          ? NetworkImage('https://www.wonderplugin.com/wp-content/uploads/2013/12/Island_1024.jpg')
                          : NetworkImage(picturePath!),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildProfileDetail('Employee ID: ', employeeId, Icons.badge),
                  _buildProfileDetail('First Name: ', employeeFirstName, Icons.person),
                  _buildProfileDetail('Last Name: ', employeeLastName, Icons.person_outline),
                  _buildProfileDetail('Role: ', employeeRole, Icons.work),
                  _buildProfileDetail('Status: ', employeeStatus, Icons.check_circle),
                  _buildProfileDetail('Position: ', employeePosition, Icons.business_center),
                  _buildProfileDetail('Branch Name: ', employeeBranchName, Icons.location_city),
                  _buildProfileDetail('Branch ID: ', employeeBranchId, Icons.map),
                  _buildProfileDetail('Section ID: ', branchSectionId, Icons.account_tree),
                  _buildProfileDetail('Section Name: ', sectionName, Icons.account_balance),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple, size: 24),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
