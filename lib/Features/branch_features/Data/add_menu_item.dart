import 'package:http/http.dart' as http;
Future<String> addMenuItem({
  required String itemName,
  required String itemDesc,
  required String categoryID,
  required String prepTime,
}) async {
  final url = 'http://192.168.56.1:4000/admin/branch/add-menu-item';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'itemName': itemName,
        'itemDesc': itemDesc,
        'categoryID': categoryID,
        'prepTime': prepTime,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final add_menu_item = response.body; // Assuming the branchId is returned in the response body
      return add_menu_item;
    } else {
      // Failure
      throw Exception('Failed to add menu item: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error add menu item: $e');
  }
}