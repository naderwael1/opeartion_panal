import 'package:bloc_v2/core/utils/helper/api_helper.dart';

import '../models/branch_model.dart';

class AddBranch {
  Future<BranchModel> addBranch({
    required String branchName,
    required String branchAddress,
    required String branchLocation,
    required String coverage,
    required String branchPhone,
  }) async {
    Map<String, dynamic> body = {
      'branchName': branchName,
      'branchAddress': branchAddress,
      'branchLocation': branchLocation,
      'coverage': coverage,
      'branchPhone': branchPhone,
    };

    Map<String, dynamic> data = await ApiHelper().post(
      url: 'http://192.168.175.1:4000/admin/branch/add-new',
      body: body,
    );

    return BranchModel.fromJson(data);
  }
}
