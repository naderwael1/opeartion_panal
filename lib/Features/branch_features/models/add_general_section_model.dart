import 'package:http/http.dart' as http;

Future<String> addGeneralSectionModel({
  required String branch_id,
  required String section_id,
  required String manager_id,
}) async {
  final url = 'http://192.168.56.1:4000/admin/branch/add-branch-section';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'branch_id': branch_id,
        'section_id': section_id,
        'manager_id': manager_id,
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
      throw Exception('Failed to add employee: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding employee: $e');
  }
}
