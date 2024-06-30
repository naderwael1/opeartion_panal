import '../models/branch_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc_v2/constants.dart';

class GetAllBranches {
  Future<List<BranchModel>> getAllBranches() async {
    final response = await http
        .get(Uri.parse('http://$baseUrl:4000/admin/branch/branches-list'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        List<dynamic> employeesData = jsonResponse['data'];
        return employeesData.map((data) => BranchModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load active employees data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}


//http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/branch/branches-list
//getAllBranches