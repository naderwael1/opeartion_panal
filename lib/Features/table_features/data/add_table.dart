import 'package:bloc_v2/core/utils/helper/api_helper.dart';

import '../models/table_model.dart';

class AddTable {
  Future<TableModel> addTable({
    required String branchId,
    required String capacity,
    required String status,
  }) async {
    Map<String, dynamic> body = {
      'branchId': branchId,
      'capacity': capacity,
      'status': status
    };
    Map<String, dynamic> data = await ApiHelper().post(
      url:
          'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/table/add-newTable',
      body: body,
    );
    print(data);

    return TableModel.fromJson(data);
  }
}
