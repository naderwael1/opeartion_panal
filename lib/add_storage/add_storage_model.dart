import 'package:http/http.dart' as http;

Future<String> addStorageModel({
  required String storageName,
  required String storageAddress,
  required String managerId,
}) async {
  final url =
      'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/branch/add-storage';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'storageName': storageName,
        'storageAddress': storageAddress,
        'managerId': managerId,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final add_menu_item = response
          .body; // Assuming the branchId is returned in the response body
      return add_menu_item;
    } else {
      // Failure
      throw Exception('Failed to Add Storage: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error AddStorage: $e');
  }
}
