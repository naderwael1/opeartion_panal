import 'package:http/http.dart' as http;
Future<String> addPosition({
  required String positionName,
  required String jopdescription,

}) async {
  final url = 'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/employees/add-position';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'position_name': positionName,
        'jop_description': jopdescription,
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
