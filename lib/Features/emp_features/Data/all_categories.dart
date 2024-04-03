import 'dart:convert';

import 'package:bloc_v2/core/utils/helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class AllDepartmentService
{

  Future<List<dynamic>> getAllDepartment() async
  {
    List<dynamic> data = await ApiHelper().get(url: 'https://fakestoreapi.com/products/categories');

  return data;
  }
}