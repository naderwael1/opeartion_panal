import 'package:http/http.dart' as http;
Future<String> addregisteremployee({
  required String ssnNumber,
  required String firstName,
  required String lastName,
  required String gender,
  required String salary,
  required String status,
}) async {
  final url = 'http://192.168.56.1:4000/admin/auth/register';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'ssn': ssnNumber,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'salary': salary,
        'status': status,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final add_menu_item = response.body; // Assuming the branchId is returned in the response body
      return add_menu_item;
    } else {
      // Failure
      throw Exception('Failed to add employee Registration: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error add employee Registration: $e');
  }
}