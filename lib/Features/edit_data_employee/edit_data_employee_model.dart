import 'dart:convert'; // Import dart:convert for JSON decoding
import 'package:http/http.dart' as http;

Future<String> editSaleryEmployee({
  required int employeeId,
  required String changerId,
  required String newSalary,
  required String changeReason,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/change-salary';
  try {
    final response = await http.patch(
      Uri.parse(url),
      body: {
        'employeeId': employeeId.toString(),
        'changerId': changerId,
        'newSalary': newSalary,
        'changeReason': changeReason,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final addMenuItem = response.body; // Assuming the response body contains the data you need
      print('Status: ${response.statusCode}');
      print('Response: $addMenuItem');
      return addMenuItem;
    } else {
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to add vacation: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding vacation: $e');
  }
}






