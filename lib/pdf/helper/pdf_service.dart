import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.10.1:4000';

  static Future<List<dynamic>> fetchSalesData(
      String startDate, String endDate, int branchId) async {
    final url =
        '$baseUrl/admin/branch/branchSales/$branchId?startDate=$startDate&endDate=$endDate';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load sales data');
    }
  }

  static Future<List<dynamic>> fetchBranchesList() async {
    final url = '$baseUrl/admin/branch/branches-list';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load branches list');
    }
  }
}
