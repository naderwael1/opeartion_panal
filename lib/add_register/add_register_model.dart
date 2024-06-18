import 'package:http/http.dart' as http;

Future<String> addregisteremployee({
  required String ssnNumber,
  required String firstName,
  required String lastName,
  required String gender,
  required String salary,
  required String positionId,
  required String status,
  required String branchId,
  required String sectionId,
  required String birthDate,
  required String address,
  required String dateHired,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/employee';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'ssn': ssnNumber,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'salary': salary,
        'positionId': positionId,
        'status': status,
        'branchId': branchId,
        'sectionId': sectionId,
        'birthDate': birthDate, 
        'address': address,
        'dateHired': dateHired,
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
      throw Exception('Failed to add employee: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding employee: $e');
  }
}

Future<String> addPhoneNumber({
  required String ssnNumber,
}) async {
  const url = 'http://192.168.205.1:4000/admin/employees/employee-phone';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'ssn': ssnNumber,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final add_menu_item = response
          .body; // Assuming the branchId is returned in the response body
      return add_menu_item;
    } else {
      // Failure
      throw Exception(
          'Failed to add employee Registration: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error add employee Registration: $e');
  }
}
