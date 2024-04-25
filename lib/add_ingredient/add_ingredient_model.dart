import 'package:http/http.dart' as http;
Future<String> addIngredient_model({
  required String name,
  required String recipeUnit,
  required String shipmentUnit,
}) async {
  final url = 'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/branch/add-ingredient';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
        'recipeUnit': recipeUnit,
        'shipmentUnit': shipmentUnit,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final add_menu_item = response.body; // Assuming the branchId is returned in the response body
      return add_menu_item;
    } else {
      // Failure
      throw Exception('Failed to Add Ingredient model: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error Add Ingredient Model: $e');
  }
}