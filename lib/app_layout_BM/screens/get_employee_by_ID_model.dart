import 'dart:convert';
import 'package:http/http.dart' as http;


class Employee {
  final int employeeId; // Changed to int
  final String firstName;
  final String lastName;

  Employee({required this.employeeId, required this.firstName, required this.lastName});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['fn_employee_id'] ?? 0, // Provide a default value if null
      firstName: json['fn_employee_first_name'] ?? '',
      lastName: json['fn_employee_last_name'] ?? '',
    );
  }
}

// Function to fetch employees
Future<List<Employee>> fetchEmployees() async {
  final response = await http.get(Uri.parse('http://192.168.56.1:4000/admin/employees/employeeData?branchId=1&status=active'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body)['data'];
    return data.map((json) => Employee.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load employees');
  }
}

