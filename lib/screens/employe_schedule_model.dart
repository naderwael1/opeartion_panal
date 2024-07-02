import 'package:http/http.dart' as http;
import 'package:bloc_v2/constants.dart';

Future<String> addEmployeeSchedule({
  required String employeeId,
  required String shiftStartTime,
  required String shiftEndTime,
}) async {
  const url = 'http://$baseUrl:4000/admin/employees/employee-schedule';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'employeeId': employeeId,
        'shiftStartTime': shiftStartTime,
        'shiftEndTime': shiftEndTime,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final addMenuItem = response
          .body; // Assuming the response body contains the data you need
      print('Status: ${response.statusCode}');
      print('Response: $addMenuItem');
      return addMenuItem;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to add Schedule: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding Schedule: $e');
  }
}
