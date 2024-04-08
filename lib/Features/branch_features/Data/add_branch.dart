import 'package:http/http.dart' as http;

Future<String> addBranch({
  required String branchName,
  required String branchAddress,
  required String branchLocation,
  required String coverage,
  required String branchPhone,
}) async {
  final url = 'http://192.168.175.1:4000/admin/branch/add-new';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'branchName': branchName,
        'branchAddress': branchAddress,
        'branchLocation': branchLocation,
        'coverage': coverage,
        'branchPhone': branchPhone,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final branchId = response.body; // Assuming the branchId is returned in the response body
      return branchId;
    } else {
      // Failure
      throw Exception('Failed to add branch: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error adding branch: $e');
  }
}
