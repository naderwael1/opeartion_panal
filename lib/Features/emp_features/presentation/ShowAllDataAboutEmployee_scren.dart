import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bloc_v2/Features/emp_features/models/active_emp_model.dart';

// PositionChangeModel class
class PositionChangeModel {
  final String? positionChanger;
  final String? previousPosition;
  final String? newPosition;
  final String? changeType;
  final String? changeDate;

  PositionChangeModel({
    this.positionChanger,
    this.previousPosition,
    this.newPosition,
    this.changeType,
    this.changeDate,
  });

  factory PositionChangeModel.fromJson(Map<String, dynamic> json) {
    return PositionChangeModel(
      positionChanger: json['position_changer'],
      previousPosition: json['previous_position'],
      newPosition: json['new_position'],
      changeType: json['change_type'],
      changeDate: json['change_date'],
    );
  }
}

// PhoneModel class
class PhoneModel {
  final String phone;

  PhoneModel({required this.phone});

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      phone: json['phone'],
    );
  }
}

// Fetch position change data function
Future<List<PositionChangeModel>> fetchPositionChanges(int employeeId) async {
  final response = await http.get(Uri.parse('http://192.168.56.1:4000/admin/employees/positionsChanges/$employeeId'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)['data']['attendance'];
    return jsonData.map((json) => PositionChangeModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load position change data');
  }
}

// Fetch phone data function
Future<List<PhoneModel>> fetchPhones(int employeeId) async {
  final response = await http.get(Uri.parse('http://192.168.56.1:4000/admin/employees/phones/$employeeId'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)['data']['phones'];
    return jsonData.map((json) => PhoneModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load phone data');
  }
}

// Utility function to capitalize the first letter of each word
String capitalize(String input) {
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

// Utility function to extract date only from datetime string
String extractDate(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime);
  return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
}

// ShowAllDataAboutEmployee screen
class ShowAllDataAboutEmployee extends StatefulWidget {
  final ActiveEmployeesModel employee;

  const ShowAllDataAboutEmployee({required this.employee, Key? key}) : super(key: key);

  @override
  _ShowAllDataAboutEmployeeState createState() => _ShowAllDataAboutEmployeeState();
}

class _ShowAllDataAboutEmployeeState extends State<ShowAllDataAboutEmployee> {
  late Future<List<PositionChangeModel>> futurePositionChanges;
  late Future<List<PhoneModel>> futurePhones;

  @override
  void initState() {
    super.initState();
    futurePositionChanges = fetchPositionChanges(widget.employee.employeeId);
    futurePhones = fetchPhones(widget.employee.employeeId);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employee Details',
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
          FutureBuilder<List<PositionChangeModel>>(
            future: futurePositionChanges,
            builder: (context, positionSnapshot) {
              if (positionSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (positionSnapshot.hasError) {
                return Center(child: Text('Error: ${positionSnapshot.error}'));
              } else if (!positionSnapshot.hasData || positionSnapshot.data!.isEmpty) {
                return FutureBuilder<List<PhoneModel>>(
                  future: futurePhones,
                  builder: (context, phoneSnapshot) {
                    if (phoneSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (phoneSnapshot.hasError) {
                      return Center(child: Text('Error: ${phoneSnapshot.error}'));
                    } else if (!phoneSnapshot.hasData || phoneSnapshot.data!.isEmpty) {
                      return Center(child: Text('No data found'));
                    } else {
                      final phones = phoneSnapshot.data!;
                      return buildDataScreen(screenSize, null, phones);
                    }
                  },
                );
              } else {
                final positionChange = positionSnapshot.data!.last;
                return FutureBuilder<List<PhoneModel>>(
                  future: futurePhones,
                  builder: (context, phoneSnapshot) {
                    if (phoneSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (phoneSnapshot.hasError) {
                      return Center(child: Text('Error: ${phoneSnapshot.error}'));
                    } else if (!phoneSnapshot.hasData || phoneSnapshot.data!.isEmpty) {
                      return buildDataScreen(screenSize, positionChange, []);
                    } else {
                      final phones = phoneSnapshot.data!;
                      return buildDataScreen(screenSize, positionChange, phones);
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildDataScreen(Size screenSize, PositionChangeModel? positionChange, List<PhoneModel> phones) {
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
                    if (positionChange != null)
                      buildInfoRow(
                        icon: Icons.person,
                        title: 'Employee Name',
                        subtitle: capitalize(widget.employee.employeeName ?? 'N/A') + ' (#${widget.employee.employeeId})',
                        screenSize: screenSize,
                      ),
                    ...phones.map((phone) => buildInfoRow(
                      icon: Icons.phone,
                      title: 'Phone',
                      subtitle: phone.phone,
                      screenSize: screenSize,
                    )),
                    if (positionChange != null) ...[
                      buildInfoRow(
                        icon: Icons.swap_horiz,
                        title: 'Position Changer',
                        subtitle: capitalize(positionChange.positionChanger ?? 'N/A'),
                        screenSize: screenSize,
                      ),
                      buildInfoRow(
                        icon: Icons.work,
                        title: 'Previous Position',
                        subtitle: capitalize(positionChange.previousPosition ?? 'N/A'),
                        screenSize: screenSize,
                      ),
                      buildInfoRow(
                        icon: Icons.work_outline,
                        title: 'New Position',
                        subtitle: capitalize(positionChange.newPosition ?? 'N/A'),
                        screenSize: screenSize,
                      ),
                      buildInfoRow(
                        icon: Icons.category,
                        title: 'Change Type',
                        subtitle: capitalize(positionChange.changeType ?? 'N/A'),
                        screenSize: screenSize,
                      ),
                      buildInfoRow(
                        icon: Icons.date_range,
                        title: 'Change Date',
                        subtitle: extractDate(positionChange.changeDate ?? 'N/A'),
                        screenSize: screenSize,
                      ),
                    ],
                    buildInfoRow(
                      icon: Icons.calendar_today,
                      title: 'Date Hired',
                      subtitle: widget.employee.employeeDateHired,
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.check_circle,
                      title: 'Status',
                      subtitle: widget.employee.employeeStatus,
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.location_city,
                      title: 'Branch',
                      subtitle: widget.employee.employeeBranch,
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.account_tree,
                      title: 'Section',
                      subtitle: widget.employee.employeeSection,
                      screenSize: screenSize,
                    ),
                    buildInfoRow(
                      icon: Icons.work_outline,
                      title: 'Position',
                      subtitle: widget.employee.employeePosition,
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