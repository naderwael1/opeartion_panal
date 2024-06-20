import 'package:http/http.dart' as http;

Future<String> addBranchModel({
  required String branchName,
  required String branchAddress,
  required String branchLocation,
  required String coverage,
  required String branchPhone,
  required String manager_id,
}) async {
  const url = 'http://192.168.56.1:4000/admin/branch/add-new';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'branchName': branchName,
        'branchAddress': branchAddress,
        'branchLocation': branchLocation,
        'coverage': coverage,
        'branchPhone': branchPhone,
        'manager_id': manager_id
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