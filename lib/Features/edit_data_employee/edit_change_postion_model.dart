import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<void> editPositionEmployee({
  required int employee_id,
  required String position_changer_id,
  required String new_position,
  required String position_change_type,
}) async {
  const url = 'http://192.168.56.1:4000/admin/employees/change-position';
  try {
    final response = await http.patch(
      Uri.parse(url),
      body: {
        'employee_id': employee_id.toString(),
        'position_changer_id': position_changer_id,
        'new_position': new_position,
        'position_change_type': position_change_type,
      },
    );

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
    Fluttertoast.showToast(
      msg: 'Error editing employee position: $e',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

void main() async {
  final result = await editPositionEmployee(
    employee_id: 1,
    position_changer_id: '1',
    new_position: '5',
    position_change_type: 'promote'
  );
}

