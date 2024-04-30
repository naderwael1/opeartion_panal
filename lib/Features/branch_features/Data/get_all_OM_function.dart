import 'package:bloc_v2/Features/branch_features/models/OM_function_model.dart';

import '../models/branch_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetCategories {
  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/branch/categories-list'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        List<dynamic> employeesData = jsonResponse['data'];
        return employeesData
            .map((data) => CategoryModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load active employees data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}
