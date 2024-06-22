import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> editSalaryAndPositionEmployee({
  required int employeeId,
  required String changerId,
  required String newSalary,
  required String newPosition,
  required String positionChangeType,
  required String changeReason,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/updateEmployeeSalaryPosition';
  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employeeId': employeeId.toString(),
        'changerId': changerId,
        'newSalary': newSalary,
        'newPosition': newPosition,
        'positionChangeType':positionChangeType,
        'changeReason': changeReason,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        final data = jsonResponse['data'] as List;
        print('Data: $data');
        return {'status': 'success', 'data': data};
      } else {
        return {'status': 'error', 'message': 'Unexpected success response format'};
      }
    } else {
      // Failure
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'] ?? 'Unknown error';
      print('Failed to edit employee phone. Status code: ${response.statusCode}, Message: $message');
      return {'status': 'error', 'message': message};
    }
  } catch (e) {
    print('Error editing employee phone: $e');
    return {'status': 'error', 'message': e.toString()};
  }
}
void main() async {
  final result = await editSalaryAndPositionEmployee(
    employeeId: 3,
    changerId: "1",
    newSalary: "9000",
    newPosition: "8",
    positionChangeType: "promote",
    changeReason: "sdaadasd",
  );
  print(result);
}