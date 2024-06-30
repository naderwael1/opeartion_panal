import '../models/active_emp_model.dart';
import '../../../core/utils/helper/api_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bloc_v2/constants.dart';

class GetActiveEmployee {
  Future<List<ActiveEmployeesModel>> fetchActiveEmployees() async {
    final response = await http.get(Uri.parse(
        'http://$baseUrl:4000/admin/employees/active-employees-list'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        List<dynamic> employeesData = jsonResponse['data'];
        return employeesData
            .map((data) => ActiveEmployeesModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load active employees data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}

class GeIntActiveEmployee {
  Future<List<ActiveEmployeesModel>> geIntActiveEmployee() async {
    final response = await http.get(Uri.parse(
        'http://$baseUrl:4000/admin/employees/inactive-employees-list'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        List<dynamic> employeesData = jsonResponse['data'];
        return employeesData
            .map((data) => ActiveEmployeesModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load active employees data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}
