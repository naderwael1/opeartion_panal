import 'dart:async';
import 'dart:convert';
import 'package:bloc_v2/add_register/style.dart';
import 'package:bloc_v2/screens/attendanceOut_model.dart';
import 'package:bloc_v2/screens/attendance_In.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendanceInAndOut extends StatefulWidget {
  const AttendanceInAndOut({Key? key}) : super(key: key);

  @override
  State<AttendanceInAndOut> createState() => _AttendanceInAndOut();
}

class _AttendanceInAndOut extends State<AttendanceInAndOut> {
  TextEditingController employeeIddController = TextEditingController();
  TextEditingController scheduleIdController = TextEditingController();
  TextEditingController employeeId1Controller = TextEditingController();
  TextEditingController scheduleId1Controller = TextEditingController();
  TextEditingController timeInController = TextEditingController();
  TextEditingController timeOutController = TextEditingController();

  int _selectedIndex = 1;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _formKeyOut = GlobalKey<FormState>();

  List<Map<String, dynamic>> activeEmployees = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchActiveEmployees();
    startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startPolling() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchActiveEmployees();
    });
  }

  Future<void> fetchActiveEmployees() async {
    final url = Uri.parse(
        'http://192.168.56.1:4000/admin/employees/active-employees-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          activeEmployees = (jsonBody['data'] as List)
              .map<Map<String, dynamic>>((employee) => {
                    'employee_id': employee['employee_id'],
                    'employee_name': employee['employee_name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load active employees');
      }
    } catch (e) {
      print('Error loading active employees: $e');
    }
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    // Pick the date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pick the time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the date and time
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format the combined date and time
        String formattedDateTime = pickedDateTime.toLocal().toString();

        // Update the controller's text
        setState(() {
          controller.text = formattedDateTime;
        });
      }
    }
  }

  void clearForm() {
    timeInController.clear();
    scheduleIdController.clear();
    setState(() {
      employeeIddController.clear();
    });
  }

    void clearFormOut() {
    timeOutController.clear();
    scheduleId1Controller.clear();
    setState(() {
      employeeId1Controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  height: 200,
                  color: baseColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 75.0),
                      ),
                      const Center(
                        child: Text(
                          'Attendance In | Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: scheduleIdController,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Schedule Id',
                        ), // Allows the text field to grow with the content
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reason for the vacation';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: employeeIddController.text.isEmpty
                            ? null
                            : int.tryParse(employeeIddController.text),
                        onChanged: (newValue) {
                          setState(() {
                            employeeIddController.text =
                                newValue?.toString() ?? '';
                          });
                        },
                        items: activeEmployees.map((employee) {
                          return DropdownMenuItem<int>(
                            value: employee['employee_id'],
                            child: Text(employee['employee_name']),
                          );
                        }).toList(),
                        decoration: inputDecoration.copyWith(
                          labelText: 'Employee Name',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an Employee Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: timeInController,
                        decoration: const InputDecoration(
                          labelText: 'Attendance In',
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDateTime(timeInController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Vacation End Date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            style: clearButtonStyle,
                            icon: const Icon(Icons.clear),
                            label: const Text("Clear"),
                            onPressed: clearForm,
                          ),
                          ElevatedButton.icon(
                            style: elevatedButtonStyle,
                            icon: const Icon(Icons.upload),
                            label: const Text("Add Attendance In"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final addRegisterEmp = AttendanceIn(
                                    scheduleId: scheduleIdController.text,
                                    employeeId: employeeIddController.text,
                                    timeIn: timeInController.text,
                                  );
                                  print(
                                      'Adding Attendance In: $addRegisterEmp');
                                  CherryToast.success(
                                    animationType: AnimationType.fromRight,
                                    toastPosition: Position.bottom,
                                    description: const Text(
                                      "Employee Attendance In successfully",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ).show(context);
                                  clearForm();
                                } catch (e) {
                                  CherryToast.error(
                                    toastPosition: Position.bottom,
                                    animationType: AnimationType.fromRight,
                                    description: const Text(
                                      "Something went wrong!",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ).show(context);
                                }
                              } else {
                                CherryToast.warning(
                                  toastPosition: Position.bottom,
                                  animationType: AnimationType.fromLeft,
                                  description: const Text(
                                    "Data is not valid or not complete",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ).show(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Form(
                  key: _formKeyOut,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: scheduleId1Controller,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Schedule Id',
                        ), // Allows the text field to grow with the content
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reason for the vacation';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: employeeId1Controller.text.isEmpty
                            ? null
                            : int.tryParse(employeeId1Controller.text),
                        onChanged: (newValue) {
                          setState(() {
                            employeeId1Controller.text =
                                newValue?.toString() ?? '';
                          });
                        },
                        items: activeEmployees.map((employee) {
                          return DropdownMenuItem<int>(
                            value: employee['employee_id'],
                            child: Text(employee['employee_name']),
                          );
                        }).toList(),
                        decoration: inputDecoration.copyWith(
                          labelText: 'Employee Name',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an Employee Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: timeOutController,
                        decoration: const InputDecoration(
                          labelText: 'Attendance In',
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDateTime(timeOutController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Vacation End Date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            style: clearButtonStyle,
                            icon: const Icon(Icons.clear),
                            label: const Text("Clear"),
                            onPressed: clearFormOut,
                          ),
                          ElevatedButton.icon(
                            style: elevatedButtonStyle,
                            icon: const Icon(Icons.upload),
                            label: const Text("Add Attendance Out"),
                            onPressed: () async {
                              if (_formKeyOut.currentState!.validate()) {
                                try {
                                  final addRegisterEmp = EmployeeOUTModel(
                                    scheduleId: scheduleId1Controller.text,
                                    employeeId: employeeId1Controller.text,
                                    timeOut: timeOutController.text,
                                  );
                                  print(
                                      'Adding Attendance Out: $addRegisterEmp');
                                  CherryToast.success(
                                    animationType: AnimationType.fromRight,
                                    toastPosition: Position.bottom,
                                    description: const Text(
                                      "Employee Attendance Out successfully",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ).show(context);
                                  clearForm();
                                } catch (e) {
                                  CherryToast.error(
                                    toastPosition: Position.bottom,
                                    animationType: AnimationType.fromRight,
                                    description: const Text(
                                      "Something went wrong!",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ).show(context);
                                }
                              } else {
                                CherryToast.warning(
                                  toastPosition: Position.bottom,
                                  animationType: AnimationType.fromLeft,
                                  description: const Text(
                                    "Data is not valid or not complete",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ).show(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
