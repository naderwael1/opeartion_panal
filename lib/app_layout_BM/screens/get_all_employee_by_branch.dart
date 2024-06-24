import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'get_employee_by_ID_model.dart'; // Import the Employee model file

class TableSreen extends StatefulWidget {
  const TableSreen({super.key});

  @override
  State<TableSreen> createState() => _TableSreenState();
}

class _TableSreenState extends State<TableSreen> {
  late Future<List<Employee>> futureEmployees;

  @override
  void initState() {
    super.initState();
    futureEmployees = fetchEmployees();
  }

  Future<void> sendTimeInAttendance(int employeeId) async {
    final response = await http.post(
      Uri.parse('http://192.168.56.1:4000/admin/employees/timeInAttendance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'employeeId': employeeId,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, show success dialog.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Success', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
            content: Text('Time in attendance successfully sent.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK', style: GoogleFonts.openSans(color: Colors.teal)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Parse the response body to get the error message.
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String errorMessage = responseData['message'] ?? 'Unknown error occurred';

      // Print the status code and response body for debugging
      print('Failed to send time in attendance. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Show error dialog with the error message from the response
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Error', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
            content: Text('Failed to send time in attendance: $errorMessage'),
            actions: <Widget>[
              TextButton(
                child: Text('OK', style: GoogleFonts.openSans(color: Colors.redAccent)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  Future<void> sendTimeOutAttendance(int employeeId) async {
    final response = await http.post(
      Uri.parse('http://192.168.56.1:4000/admin/employees/timeOutAttendance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'employeeId': employeeId,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, show success dialog.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Success', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
            content: Text('Time in attendance successfully sent.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK', style: GoogleFonts.openSans(color: Colors.teal)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Parse the response body to get the error message.
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String errorMessage = responseData['message'] ?? 'Unknown error occurred';

      // Print the status code and response body for debugging
      print('Failed to send time in attendance. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Show error dialog with the error message from the response
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Error', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
            content: Text('Failed to send time in attendance: $errorMessage'),
            actions: <Widget>[
              TextButton(
                child: Text('OK', style: GoogleFonts.openSans(color: Colors.redAccent)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<Employee>>(
        future: futureEmployees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final employee = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_downward, color: Colors.redAccent),
                      onPressed: () {
                        sendTimeOutAttendance(employee.employeeId);
                      },
                    ),
                    title: Center(
                      child: Text(
                        '${employee.firstName} ${employee.lastName}',
                        style: GoogleFonts.openSans(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_upward, color: Colors.teal),
                      onPressed: () {
                        sendTimeInAttendance(employee.employeeId);
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
