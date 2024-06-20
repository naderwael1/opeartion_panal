import 'package:http/http.dart' as http;

Future<String> addPosition({
  required String positionName,
  required String employeeRole,
  required String jop_description,
}) async {
  final url = 'http://192.168.56.1:4000/admin/employees/add-position';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'position_name': positionName,
        'employeeRole': employeeRole,
        'jop_description': jop_description,
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
      throw Exception('Failed to add Posistion: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding Posistion: $e');
  }
}
