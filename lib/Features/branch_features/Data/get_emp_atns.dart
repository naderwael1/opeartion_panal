import 'package:bloc_v2/Features/branch_features/models/employeesAttendance_model.dart';

import '../models/branch_model.dart';
import '../../../core/utils/helper/api_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetEmpAtndance {
  Future<List<EmployeesAttendanceModel>> getEmpAtndance({
    required String branch_id,
  }) async {
    final String url =
        'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/branch/employeesAttendance/$branch_id?fromDate=2024-04-10&toDate=2024-04-11';
    print('URL: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success' &&
          jsonResponse['data']['attendance'] is List) {
        List<dynamic> employeesData = jsonResponse['data']['attendance'];
        return employeesData
            .map((data) => EmployeesAttendanceModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load active employees data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}
