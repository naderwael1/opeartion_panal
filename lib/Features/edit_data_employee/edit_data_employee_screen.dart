import 'package:bloc_v2/Features/edit_data_employee/edit_address_employee_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_change_postion_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_data_employee_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_phone_employee_model.dart';
import 'package:flutter/material.dart';
import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/add_register/style.dart';
import 'package:flutter/services.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditEmployeeScreen extends StatefulWidget {
  final int employeeId;

  const EditEmployeeScreen({
    required this.employeeId,
    Key? key,
  }) : super(key: key);

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController changerIdController = TextEditingController();
  TextEditingController newSalaryController = TextEditingController();
  TextEditingController changeReasonController = TextEditingController();
  TextEditingController oldPhoneController = TextEditingController();
  TextEditingController newPhoneController = TextEditingController();
  TextEditingController newAddressController = TextEditingController();
  TextEditingController positionchangetypeController = TextEditingController();
  TextEditingController selectedPositionId1Controller = TextEditingController();
  TextEditingController selectedPositionId2Controller = TextEditingController();

  List<Map<String, dynamic>> positions = [];
  int? selectedPositionId1; // State variable for the first dropdown
  int? selectedPositionId2; // State variable for the second dropdown

  final GlobalKey<FormState> _formKeyPosition = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchPositions().then((data) {
      setState(() {
        positions = data;
      });
    }).catchError((error) {
      print('Error loading positions: $error');
    });
  }

  Future<List<Map<String, dynamic>>> fetchPositions() async {
    final response = await http.get(
        Uri.parse('http://192.168.56.1:4000/admin/employees/positions-list'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      List<dynamic> positionsData = jsonBody['data'];
      return positionsData
          .map((position) => {
                'position_id': position['position_id'],
                'position': position['position'],
              })
          .toList();
    } else {
      throw Exception('Failed to load positions');
    }
  }

  int _selectedIndex = 1;

  bool isEditing = false;
  final _formKeySalary = GlobalKey<FormState>();
  final _formKeySalarys = GlobalKey<FormState>();

  final _formKeyAddress = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();

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
    changerIdController.clear();
    newSalaryController.clear();
    changeReasonController.clear();
  }

  void clearAddressForm() {
    newAddressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee ${widget.employeeId}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                height: 200,
                color: baseColor,
                child: Center(
                  child: Text(
                    'Edit Employee ${widget.employeeId}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Form(
                    key: _formKeySalary,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: changerIdController.text.isEmpty
                              ? null
                              : changerIdController.text,
                          onChanged: (newValue) {
                            setState(() {
                              changerIdController.text = newValue!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: '1',
                              child: Text('General Manager'),
                            ),
                            DropdownMenuItem(
                              value: '2',
                              child: Text('Operation Manager'),
                            ),
                          ],
                          decoration: inputDecoration.copyWith(
                            labelText: 'Changer',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a Changer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: newSalaryController,
                          keyboardType: TextInputType.number,
                          key: const ValueKey('New Salary'),
                          decoration: inputDecoration.copyWith(
                            labelText: 'New Salary',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a New Salary';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: changeReasonController,
                          key: const ValueKey('Job Description'),
                          minLines: 5,
                          maxLines: 8,
                          maxLength: 100,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Reason Description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a job description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              style: clearButtonStyle,
                              icon: const Icon(Icons.clear),
                              label: const Text("Clear"),
                              onPressed: () async {
                                clearForm();
                                setState(() {
                                  changerIdController.text = '';
                                });
                              },
                            ),
                            ElevatedButton.icon(
                              style: elevatedButtonStyle,
                              icon: const Icon(Icons.upload),
                              label: const Text("Change Salary"),
                              onPressed: () async {
                                if (_formKeySalary.currentState!.validate()) {
                                  try {
                                    final editedEmployee =
                                        await editSaleryEmployee(
                                      employeeId: widget.employeeId,
                                      changerId: changerIdController.text,
                                      newSalary: newSalaryController.text,
                                      changeReason: changeReasonController.text,
                                    );
                                    print(
                                        'Edit salary employee: $editedEmployee');
                                    CherryToast.success(
                                      animationType: AnimationType.fromRight,
                                      toastPosition: Position.bottom,
                                      description: const Text(
                                        "Edit salary successfully",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ).show(context);
                                    clearForm();
                                    setState(() {
                                      changerIdController.text = '';
                                    });
                                  } catch (e) {
                                    // Print the error message
                                    print('Error: $e');
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
                  const SizedBox(height: 30), // Add some spacing
                  Form(
                    key: _formKeyAddress,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller:
                              newAddressController, // New TextFormField controller
                          key: const ValueKey('Change Address'),
                          decoration: inputDecoration.copyWith(
                            labelText: 'Change Address',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the Change Address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30), // Add some spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              style: clearButtonStyle,
                              icon: const Icon(Icons.clear),
                              label: const Text("Clear"),
                              onPressed: () async {
                                clearAddressForm();
                              },
                            ),
                            ElevatedButton.icon(
                              style: elevatedButtonStyle,
                              icon: const Icon(Icons.upload),
                              label: const Text("Change Address"),
                              onPressed: () async {
                                if (_formKeyAddress.currentState!.validate()) {
                                  try {
                                    final editedEmployee =
                                        await editAddressEmployee(
                                      employeeId: widget.employeeId,
                                      newAddress: newAddressController.text,
                                    );
                                    print(
                                        'Edit address employee: $editedEmployee');
                                    CherryToast.success(
                                      animationType: AnimationType.fromRight,
                                      toastPosition: Position.bottom,
                                      description: const Text(
                                        "Edit address successfully",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ).show(context);
                                    clearAddressForm();
                                  } catch (e) {
                                    // Print the error message
                                    print('Error: $e');
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
                  const SizedBox(height: 30),
                  Form(
                    key: _formKeyPhone, // Ensure the form key is assigned here
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: oldPhoneController,
                          key: const ValueKey('Old Phone'),
                          decoration: inputDecoration.copyWith(
                            labelText: 'Old Phone',
                          ),
                          maxLength: 11,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the Old Phone';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: newPhoneController,
                          key: const ValueKey('new Phone'),
                          decoration: inputDecoration.copyWith(
                            labelText: 'New Phone',
                          ),
                          maxLength: 11,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the New Phone';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              style: clearButtonStyle,
                              icon: const Icon(Icons.clear),
                              label: const Text("Clear"),
                              onPressed: () async {
                                oldPhoneController.clear();
                                newPhoneController.clear();
                              },
                            ),
                            ElevatedButton.icon(
                              style: elevatedButtonStyle,
                              icon: const Icon(Icons.upload),
                              label: const Text("Change Phone"),
                              onPressed: () async {
                                if (_formKeyPhone.currentState!.validate()) {
                                  try {
                                    final editedEmployee =
                                        await editPhoneEmployee(
                                      employeeId: widget.employeeId,
                                      oldPhone: oldPhoneController.text,
                                      newPhone: newPhoneController.text,
                                    );
                                    print(
                                        'Edit phone employee: $editedEmployee');
                                    CherryToast.success(
                                      animationType: AnimationType.fromRight,
                                      toastPosition: Position.bottom,
                                      description: const Text(
                                        "Edit phone successfully",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ).show(context);
                                    oldPhoneController.clear();
                                    newPhoneController.clear();
                                  } catch (e) {
                                    // Print the error message
                                    print('Error: $e');
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
                        const SizedBox(height: 30),
                        Form(
                          key: _formKeySalarys,
                          child: Column(
                            children: [
                              DropdownButtonFormField<int>(
                                value:
                                    selectedPositionId1Controller.text.isEmpty
                                        ? null
                                        : int.tryParse(
                                            selectedPositionId1Controller.text),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedPositionId1Controller.text =
                                        newValue?.toString() ?? '';
                                  });
                                },
                                items: positions.map((position) {
                                  return DropdownMenuItem<int>(
                                    value: position['position_id'],
                                    child: Text(position['position']),
                                  );
                                }).toList(),
                                decoration: inputDecoration.copyWith(
                                  labelText: 'position changer id',
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a position changer id';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              DropdownButtonFormField<int>(
                                value:
                                    selectedPositionId2Controller.text.isEmpty
                                        ? null
                                        : int.tryParse(
                                            selectedPositionId2Controller.text),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedPositionId2Controller.text =
                                        newValue?.toString() ?? '';
                                  });
                                },
                                items: positions.map((position) {
                                  return DropdownMenuItem<int>(
                                    value: position['position_id'],
                                    child: Text(position['position']),
                                  );
                                }).toList(),
                                decoration: inputDecoration.copyWith(
                                  labelText: 'position changer id',
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a position changer id';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              DropdownButtonFormField<String>(
                                value: positionchangetypeController.text.isEmpty
                                    ? null
                                    : positionchangetypeController.text,
                                onChanged: (newValue) {
                                  setState(() {
                                    positionchangetypeController.text =
                                        newValue!;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'promote',
                                    child: Text('promote'),
                                  ),
                                ],
                                decoration: inputDecoration.copyWith(
                                  labelText: 'position change type',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a position change type';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                    style: clearButtonStyle,
                                    icon: const Icon(Icons.clear),
                                    label: const Text("Clear"),
                                    onPressed: () async {
                                      clearForm();
                                      setState(() {
                                        selectedPositionId1Controller.clear();
                                        selectedPositionId2Controller.clear();
                                        positionchangetypeController.clear();
                                      });
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    style: elevatedButtonStyle,
                                    icon: const Icon(Icons.upload),
                                    label: const Text("Change Position"),
                                    onPressed: () async {
                                      if (_formKeySalarys.currentState!
                                          .validate()) {
                                        try {
                                          final editedEmployee =
                                              await editPositionEmployee(
                                            employee_id: widget.employeeId,
                                            position_changer_id:
                                                selectedPositionId1Controller
                                                    .text,
                                            new_position:
                                                selectedPositionId2Controller
                                                    .text,
                                            position_change_type:
                                                positionchangetypeController
                                                    .text,
                                          );
                                          print(
                                              'Edit position employee: $editedEmployee');
                                          CherryToast.success(
                                            animationType:
                                                AnimationType.fromRight,
                                            toastPosition: Position.bottom,
                                            description: const Text(
                                              "Edit position successfully",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ).show(context);
                                          selectedPositionId1Controller.clear();
                                          selectedPositionId2Controller.clear();
                                          positionchangetypeController.clear();
                                          setState(() {
                                            changerIdController.text = '';
                                          });
                                        } catch (e) {
                                          // Print the error message
                                          print('Error: $e');
                                          CherryToast.error(
                                            toastPosition: Position.bottom,
                                            animationType:
                                                AnimationType.fromRight,
                                            description: const Text(
                                              "Something went wrong!",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ).show(context);
                                        }
                                      } else {
                                        CherryToast.warning(
                                          toastPosition: Position.bottom,
                                          animationType: AnimationType.fromLeft,
                                          description: const Text(
                                            "Data is not valid or not complete",
                                            style:
                                                TextStyle(color: Colors.black),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
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