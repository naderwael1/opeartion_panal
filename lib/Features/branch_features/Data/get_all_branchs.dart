import 'package:flutter/material.dart';


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '';
import '../models/branch_model.dart';
import '../../../core/utils/helper/api_helper.dart';

class GetAllBranches {
  Future<List<BranchModel>> getAllBranches() async {
    List<dynamic> data = await ApiHelper().get(url: "http://192.168.175.1:4000/admin/branch/list");


    List<BranchModel>BranchesList = [];
    for (int i=0;i<data.length;i++)
    {
      BranchesList.add(BranchModel.fromJson(data[i]));
    }
    return BranchesList;

  }
}
