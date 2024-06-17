import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> editPhoneEmployee({
  required int employeeId,
  required String oldPhone,
  required String newPhone,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/update-employee-phone';
  try {
    final response = await http.patch(
      Uri.parse(url),
      body: {
        'employeeId': employeeId.toString(),
        'oldPhone': oldPhone,
        'newPhone': newPhone,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
      return {'status': 'success', 'message': message};
    } else {
      // Failure
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
      return {'status': 'success', 'message': message};
      throw Exception('Failed to edit employee Phone. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error editing employee Phone: $e');
  }
}

