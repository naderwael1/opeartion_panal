import 'dart:convert'; // Import dart:convert for JSON decoding
import 'package:http/http.dart' as http;

Future<String> editSaleryEmployee({
  required int employeeId,
  required String changerId,
  required String newSalary,
  required String changeReason,
}) async {
  const url = 'https://51.44.5.35.nip.io/admin/employees/change-salary';
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
      // Success
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
      return message;
    } else {
      // Failure
      throw Exception(
          'Failed to edit employee salary. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error editing employee salary: $e');
  }
}
