import 'package:http/http.dart' as http;

Future<String> addPosition({
  required String positionName,
  required String jobDescription,
}) async {
  final url = 'http://192.168.56.1:4000/admin/employees/add-position';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'position_name': positionName,
        'job_description': jobDescription,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final positionId = response.body; // Assuming the positionId is returned in the response body
      print('Response Body: $positionId'); // Print response body
      return positionId;
    } else {
      // Failure
      throw Exception('Failed to add position: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error adding position: $e');
  }
}



