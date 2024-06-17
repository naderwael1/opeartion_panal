import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> editPositionEmployee({
  required int employee_id,
  required String position_changer_id,
  required String new_position,
  required String position_change_type,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/change-position';
  try {
    final response = await http.patch(
      Uri.parse(url),
      body: {
        'employee_id': employee_id.toString(),
        'position_changer_id': position_changer_id,
        'new_position': new_position,
        'position_change_type': position_change_type,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
      return {'message': message};
    } else {
      // Failure
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
      return {'message': message};
      throw Exception('Failed to edit employee position. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error editing employee position: $e');
  }
}

void main() async {
  try {
    final result = await editPositionEmployee(
      employee_id: 3,
      position_changer_id: '1',
      new_position: '15',
      position_change_type: 'promote',
    );
    print("hi");
    print(result['message']); // Print the message
  } catch (e) {
    print(e);
  }
}
