import 'package:http/http.dart' as http;

Future<String> addGeneralSectionModel({
  required String section_name,
  required String section_description,
}) async {
  const url = 'http://192.168.56.1:4000/admin/branch/add-general-section';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'section_name': section_name,
        'section_description': section_description,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final branchId = response.body;
      print('Status: ${response.statusCode}');
      print('Branch added successfully. Branch ID: $branchId');
      return branchId;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Failed to add branch: ${response.body}');
      throw Exception('Failed to add branch: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding branch: $e');
  }
}