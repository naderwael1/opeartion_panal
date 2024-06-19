import 'package:http/http.dart' as http;

Future<String> addMenuItem({
  required String itemName,
  required String itemDesc,
  required String categoryID,
  required String prepTime,
  required String picPath,
  required String vegetarian,
  required String healthy,
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
        'picPath': picPath,
        'vegetarian': vegetarian,
        'healthy': healthy,
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
