import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/add_register/style.dart';
import 'package:bloc_v2/screens/employe_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddEmployeeSchedule extends StatefulWidget {
  const AddEmployeeSchedule({Key? key}) : super(key: key);

  @override
  State<AddEmployeeSchedule> createState() => _AddEmployeeSchedule();
}

class _AddEmployeeSchedule extends State<AddEmployeeSchedule> {
  TextEditingController employeeIddController = TextEditingController();
  TextEditingController shiftStartTimeController = TextEditingController();
  TextEditingController shiftEndTimeController = TextEditingController();

  int _selectedIndex = 1;

  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Navigate to a screen, for example
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AllEmployeeScreen()));
    }
  }

  void clearForm() {
    shiftEndTimeController.clear();
    shiftStartTimeController.clear();
    setState(() {
      employeeIddController.clear();
    });
  }

  List<Map<String, dynamic>> activeEmployees = [];

  @override
  void initState() {
    super.initState();
    fetchActiveEmployees();
  }

  Future<void> fetchActiveEmployees() async {
    final url = Uri.parse('http://192.168.56.1:4000/admin/employees/active-employees-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          activeEmployees = jsonBody['data']
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Format the picked date to show only the date part (yyyy-MM-dd)
      String formattedDate = picked.toLocal().toString().split(' ')[0];

      setState(() {
        shiftStartTimeController.text = formattedDate; // Update birthDateController
      });
    }
  }

  Future<void> _HiredDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Format the picked date to show only the date part (yyyy-MM-dd)
      String formattedDate = picked.toLocal().toString().split(' ')[0];

      setState(() {
        shiftEndTimeController.text = formattedDate; // Update dateHiredController
      });
    }
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
                  height: 200, // Adjusted height to fit the toolbar and text
                  color: baseColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 75.0), // Padding above the toolbar
                      ),
                      const Center(
                        child: Text(
                          'Add Employee Schedule',
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
                        items: activeEmployees.map((section) {
                          return DropdownMenuItem<int>(
                            value: section['employee_id'],
                            child: Text(section['employee_name']),
                          );
                        }).toList(),
                        decoration: inputDecoration.copyWith(
                          labelText: 'Employee Name',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a Employee Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: shiftStartTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Shift Start Time',
                          filled: true,
                          prefixIcon: const Icon(Icons.calendar_today),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate();
                        },
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: shiftEndTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Shift End Time',
                          filled: true,
                          prefixIcon: const Icon(Icons.calendar_today),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          _HiredDate();
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
                            label: const Text("Add Register Employee"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final addRegisterEmp =
                                      await addEmployeeSchedule(
                                    employeeId: employeeIddController.text,
                                    shiftStartTime: shiftStartTimeController.text,
                                    shiftEndTime: shiftEndTimeController.text,
                                  );
                                  print('Adding employee: $addRegisterEmp');
                                  CherryToast.success(
                                    animationType: AnimationType.fromRight,
                                    toastPosition: Position.bottom,
                                    description: const Text(
                                      "Employee registered successfully",
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
    path.lineTo(0, size.height - 30); // Adjusted height of the clip path
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
