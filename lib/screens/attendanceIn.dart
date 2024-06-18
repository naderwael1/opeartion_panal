import 'dart:convert';
import 'package:bloc_v2/add_register/style.dart';
import 'package:bloc_v2/screens/attendanceIn_model.dart';
import 'package:bloc_v2/screens/attendanceOut_model.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Attendancein extends StatefulWidget {
  const Attendancein({Key? key}) : super(key: key);

  @override
  State<Attendancein> createState() => _Attendancein();
}

class _Attendancein extends State<Attendancein> {
  TextEditingController employeeIddController = TextEditingController();
  TextEditingController employeeIdd1Controller = TextEditingController();
  TextEditingController scheduleIdController = TextEditingController();
  TextEditingController scheduleId1Controller = TextEditingController();
  TextEditingController timeInController = TextEditingController();
  TextEditingController timeOutController =
      TextEditingController(); // Added for time out

  int _selectedIndex = 1;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> activeEmployees = [];
  final _formKeyOut = GlobalKey<FormState>(); // New form key for attendance out

  @override
  void initState() {
    super.initState();
    fetchActiveEmployees();
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

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        String formattedDateTime = pickedDateTime.toLocal().toString();
        setState(() {
          controller.text = formattedDateTime;
        });
      }
    }
  }

  void clearForm() {
    timeInController.clear();
    timeOutController.clear();
    scheduleIdController.clear();
    scheduleId1Controller.clear();
    setState(() {
      employeeIddController.clear();
      employeeIdd1Controller.clear();
    });}

    void clearFormOut() {
    timeOutController.clear();
    scheduleId1Controller.clear();
    setState(() {
      employeeIdd1Controller.clear();
    });}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Your existing widgets for header and main content
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
                          'Employee Attendance In | Out',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Attendance In Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: scheduleIdController,
                            decoration: inputDecoration.copyWith(
                              labelText: 'Schedule Id',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Schedule Id';
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
                          const SizedBox(height: 20),
                          TextField(
                            controller: timeInController,
                            decoration: const InputDecoration(
                              labelText: 'Time in Attendance',
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
                              _selectDate(timeInController);
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
                                label: const Text("Attendance In"),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final addRegisterEmp = EmployeeInModel(
                                        scheduleId: employeeIddController.text,
                                        employeeId: employeeIddController.text,
                                        timeIn: timeInController.text,
                                      );
                                      print('Adding employee: $addRegisterEmp');
                                      CherryToast.success(
                                        animationType: AnimationType.fromRight,
                                        toastPosition: Position.bottom,
                                        description: const Text(
                                          "Employee Time In attendance successfully",
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
                    // Attendance Out Form
                    Form(
                      key: _formKeyOut,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller:
                                scheduleId1Controller, // Consider using a separate controller for time out
                            decoration: inputDecoration.copyWith(
                              labelText: 'Schedule Id',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Schedule Id';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<int>(
                            value: employeeIdd1Controller.text.isEmpty
                                ? null
                                : int.tryParse(employeeIdd1Controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                employeeIdd1Controller.text =
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
                          const SizedBox(height: 20),
                          TextField(
                            controller:
                                timeOutController, // Controller for time out
                            decoration: const InputDecoration(
                              labelText: 'Time out Attendance',
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
                              _selectDate(
                                  timeOutController); // Use a separate method for selecting time out
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
                                label: const Text("Attendance Out"),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final addRegisterEmp = EmployeeOUTModel(
                                        scheduleId: employeeIdd1Controller.text,
                                        employeeId: employeeIdd1Controller.text,
                                        timeOut: timeOutController.text,
                                      );
                                      print('Adding employee: $addRegisterEmp');
                                      CherryToast.success(
                                        animationType: AnimationType.fromRight,
                                        toastPosition: Position.bottom,
                                        description: const Text(
                                          "Employee Time Out attendance successfully",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ).show(context);
                                      clearFormOut();
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
                  ],
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
