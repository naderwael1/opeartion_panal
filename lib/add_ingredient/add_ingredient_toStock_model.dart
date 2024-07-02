import 'package:http/http.dart' as http;
import 'package:bloc_v2/constants.dart';

Future<String> addIngredientToStock_model({
  required String branchId,
  required String ingredientId,
  required String ingredientQuantity,
}) async {
  final url = 'http://$baseUrl:4000/admin/branch/addIngredientToStock';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'branchId': branchId,
        'ingredientId': ingredientId,
        'ingredientQuantity': ingredientQuantity,
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
