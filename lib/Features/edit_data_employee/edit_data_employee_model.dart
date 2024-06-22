import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<void> editSaleryEmployee({
  required int employeeId,
  required String changerId,
  required String newSalary,
  required String changeReason,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/change-salary';
  try {
    final response = await http.patch(
      Uri.parse(url),
      body: {
        'employeeId': employeeId.toString(),
        'changerId': changerId,
        'newSalary': newSalary,
        'changeReason': changeReason,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // Failure
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } catch (e) {
    print('Error: $e');
  }
}

void main() async {
  await editSaleryEmployee(
    employeeId: 1,
    changerId: 'adfasfasdf',
    newSalary: '1000',
    changeReason: 'asdfasdf',
  );
}
