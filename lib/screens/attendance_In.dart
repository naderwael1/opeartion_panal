import 'package:http/http.dart' as http;
Future<String> AttendanceIn({
  required String scheduleId,
  required String employeeId,
  required String timeIn,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/timeInAttendance';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'scheduleId': scheduleId,
        'employeeId': employeeId, 
        'timeIn': timeIn,
      },
    ); 
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final addMenuItem = response.body; // Assuming the response body contains the data you need
      print('Status: ${response.statusCode}');
      print('Response: $addMenuItem');
      return addMenuItem;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to add AttendanceInOut: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding AttendanceInOut: $e');
  }
}