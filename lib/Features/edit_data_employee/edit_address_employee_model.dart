import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> editAddressEmployee({
  required int employeeId,
  required String newAddress,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/update-employee-address';
  
  try {
    final response = await http.patch(
      Uri.parse(url),
      body: {
        'employeeId': employeeId.toString(),
        'newAddress': newAddress,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
      return {'status': 'success', 'message': message};
    } else {
      // Failure
      throw Exception('Failed to edit employee address. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error editing employee address: $e');
  }
}

