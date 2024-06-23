import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ShowDetailsBranch screen
class ShowDetailsBranch extends StatefulWidget {
  final int branchId;
  const ShowDetailsBranch({required this.branchId, Key? key}) : super(key: key);

  @override
  _ShowDetailsBranchState createState() => _ShowDetailsBranchState();
}

class _ShowDetailsBranchState extends State<ShowDetailsBranch> {
  late Future<Branch> futureBranch;

  @override
  void initState() {
    super.initState();
    futureBranch = fetchBranchDetails(widget.branchId);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Branch Details',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(), // Custom clipper if needed
            child: Container(
              color: Colors.teal.withOpacity(0.2),
              height: screenSize.height * 0.25,
            ),
          ),
          FutureBuilder<Branch>(
            future: futureBranch,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No Data Found'));
              } else {
                final branch = snapshot.data!;
                return buildDataScreen(screenSize, branch);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildDataScreen(Size screenSize, Branch branch) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.01),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.05),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenSize.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildInfoRow(
                      icon: Icons.location_city,
                      title: 'Branch Name',
                      subtitle: capitalize(branch.name),
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.location_on,
                      title: 'Address',
                      subtitle: capitalize(branch.address),
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.phone,
                      title: 'Phone',
                      subtitle: branch.phone,
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.calendar_today,
                      title: 'Created Date',
                      subtitle: extractDate(branch.createdDate),
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.map,
                      title: 'Location',
                      subtitle: '(${branch.latitude}, ${branch.longitude})',
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.security,
                      title: 'Coverage',
                      subtitle: '${branch.coverage} km',
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.person,
                      title: 'Manager',
                      subtitle: capitalize('${branch.managerName} (ID: ${branch.managerId})'),
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.table_chart,
                      title: 'Tables',
                      subtitle: branch.tables,
                      screenSize: screenSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Size screenSize,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: screenSize.width * 0.08),
          SizedBox(width: screenSize.width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Example of a custom clipper if needed
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}







// Branch Model class
class Branch {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String createdDate;
  final double latitude;
  final double longitude;
  final int coverage;
  final String managerName;
  final int managerId;
  final String tables;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.createdDate,
    required this.latitude,
    required this.longitude,
    required this.coverage,
    required this.managerName,
    required this.managerId,
    required this.tables,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['fn_branch_id'],
      name: json['fn_branch_name'],
      address: json['fn_branch_address'],
      phone: json['fn_branch_phone'],
      createdDate: json['fn_branch_created_date'],
      latitude: json['fn_location_coordinates']['x'],
      longitude: json['fn_location_coordinates']['y'],
      coverage: json['fn_coverage'],
      managerName: json['fn_manager_name'],
      managerId: json['fn_manager_id'],
      tables: json['fn_branch_tables'],
    );
  }
}

// Fetch branch details function
Future<Branch> fetchBranchDetails(int branchId) async {
  final response = await http.get(Uri.parse('http://192.168.56.1:4000/admin/branch/branches/$branchId'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return Branch.fromJson(jsonResponse['data'][0]);
  } else {
    throw Exception('Failed to load branch details');
  }
}

// Utility function to extract date only from datetime string
String extractDate(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime);
  return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
}

// Utility function to capitalize the first letter of each word
String capitalize(String input) {
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}