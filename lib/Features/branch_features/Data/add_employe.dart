import 'package:http/http.dart' as http;
Future<String> addEmploye({
  required String idNumber,
  required String email,
  required String password,
}) async {
  final url = 'http://192.168.56.1:4000/admin/auth/customer-account';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': idNumber,
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final add_menu_item = response.body; // Assuming the branchId is returned in the response body
      return add_menu_item;
    } else {
      // Failure
      throw Exception('Failed to add employee: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error add employee: $e');
  }
}