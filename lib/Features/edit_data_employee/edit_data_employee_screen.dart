import 'dart:convert';
import 'package:bloc_v2/Features/edit_data_employee/edit_address_employee_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_change_postion_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_data_employee_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_phone_employee_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_salary_position.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class EditEmployeeScreen extends StatefulWidget {
  final int employeeId;

  const EditEmployeeScreen({
    required this.employeeId,
    Key? key,
  }) : super(key: key);

  @override
  _EditEmployeeScreen createState() => _EditEmployeeScreen();
}

class _EditEmployeeScreen extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  void clearFormFields() {
    _formKey.currentState?.reset();
  }

  Future<List<String>> fetchPhones(int employeeId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1:4000/admin/employees/phones/$employeeId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final phones = data['data']['phones'] as List;
      return phones.map((phone) => phone['phone'].toString()).toList();
    } else {
      throw Exception('Failed to load phones');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPositions() async {
    final response = await http.get(
        Uri.parse('http://192.168.56.1:4000/admin/employees/positions-list'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final positions = data['data'] as List;
      return positions
          .map((position) => {
                'position_id': position['position_id'],
                'position': position['position']
              })
          .toList();
    } else {
      throw Exception('Failed to load positions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Employee', style: GoogleFonts.lato()),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FutureBuilder<List<String>>(
                  future: fetchPhones(widget.employeeId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return FunctionInputTile(
                        functionName: 'Update Employee Phone',
                        attributeNames: const ['oldPhone', 'newPhone'],
                        oldPhoneDropdownItems: snapshot.data!,
                        onSubmit: (values) async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final addStorage_Model = await editPhoneEmployee(
                                employeeId: widget.employeeId,
                                oldPhone: values['oldPhone']!,
                                newPhone: values['newPhone']!,
                              );
                              print('Adding Storage: $addStorage_Model');
                              CherryToast.success(
                                animationType: AnimationType.fromRight,
                                toastPosition: Position.bottom,
                                description: const Text(
                                  "Changed Number successfully",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ).show(context);
                              clearFormFields();
                            } catch (e) {
                              print('Error Changed Number : $e');
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
                            print('Form is not valid');
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
                      );
                    }
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchPositions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return FunctionInputTile(
                        functionName: 'Change Position',
                        attributeNames: const [
                          'position_changer_id',
                          'new_position',
                          'position_change_type'
                        ],
                        newPositionDropdownItems:
                            snapshot.data!, // Pass fetched positions
                        onSubmit: (values) async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final addStorage_Model =
                                  await editPositionEmployee(
                                employee_id: widget.employeeId,
                                position_changer_id:
                                    values['position_changer_id']!,
                                new_position: values['new_position']!,
                                position_change_type:
                                    values['position_change_type']!,
                              );
                            } catch (e) {
                              print('Error Changed Salary : $e');
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
                            print('Form is not valid');
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
                      );
                    }
                  },
                ),
                FunctionInputTile(
                  functionName: 'Change Salary',
                  attributeNames: const [
                    'changerId',
                    'newSalary',
                    'changeReason'
                  ],
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await editSaleryEmployee(
                          employeeId: widget.employeeId,
                          changerId: values['changerId']!,
                          newSalary: values['newSalary']!,
                          changeReason: values['changeReason']!,
                        );
                        print('Adding Storage: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Changed Salary successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error Changed Salary : $e');
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
                      print('Form is not valid');
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
                FunctionInputTile(
                  functionName: 'Update Employee Address',
                  attributeNames: const ['newAddress'],
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await editAddressEmployee(
                          employeeId: widget.employeeId,
                          newAddress: values['newAddress']!,
                        );
                        print('Adding Storage: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Add Storage successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error adding storage: $e');
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
                      print('Form is not valid');
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
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchPositions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return FunctionInputTile(
                        functionName: 'Edit Employee Salary And Position',
                        attributeNames: const [
                          'changerId',
                          'newSalary',
                          'newPosition',
                          'positionChangeType',
                          'changeReason'
                        ],
                        newPositionDropdownItems: snapshot.data!,
                        onSubmit: (values) async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final addStorage_Model =
                                  await editSalaryAndPositionEmployee(
                                employeeId: widget.employeeId,
                                changerId: values['changerId']!,
                                newSalary: values['newSalary']!,
                                newPosition: values['newPosition']!,
                                positionChangeType:
                                    values['positionChangeType']!,
                                changeReason: values['changeReason']!,
                              );
                              print('Adding Storage: $addStorage_Model');
                              CherryToast.success(
                                animationType: AnimationType.fromRight,
                                toastPosition: Position.bottom,
                                description: const Text(
                                  "Changed Salary and Position successfully",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ).show(context);
                              clearFormFields();
                            } catch (e) {
                              print('Error Changed Salary and Position : $e');
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
                            print('Form is not valid');
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
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FunctionInputTile extends StatefulWidget {
  final String functionName;
  final List<String> attributeNames;
  final void Function(Map<String, String> values) onSubmit;
  final List<String>? oldPhoneDropdownItems;
  final List<Map<String, dynamic>>? newPositionDropdownItems;

  FunctionInputTile({
    required this.functionName,
    required this.attributeNames,
    required this.onSubmit,
    this.oldPhoneDropdownItems,
    this.newPositionDropdownItems,
  });

  @override
  _FunctionInputTileState createState() => _FunctionInputTileState();
}

class _FunctionInputTileState extends State<FunctionInputTile> {
  late List<TextEditingController> _textControllers;
  bool _isExpanded = false;
  String? selectedOldPhone;
  String? selectedNewPosition;
  final List<String> positionChangeTypes = ['Promote', 'Demote'];
  String? selectedPositionChangeType;

  @override
  void initState() {
    super.initState();
    _textControllers =
        widget.attributeNames.map((_) => TextEditingController()).toList();
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ClipPath(
        clipper: MyCustomClipper(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            title: Text(widget.functionName,
                style: GoogleFonts.lato(fontSize: 18, color: Colors.teal)),
            onExpansionChanged: (expanded) {
              _toggleExpand();
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ..._textControllers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      TextEditingController controller = entry.value;
                      if (widget.attributeNames[idx] == 'oldPhone' &&
                          widget.oldPhoneDropdownItems != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedOldPhone,
                            items: widget.oldPhoneDropdownItems!.map((phone) {
                              return DropdownMenuItem(
                                value: phone,
                                child: Text(phone),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedOldPhone = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'Old Phone',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a phone';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] == 'new_position' ||
                          widget.attributeNames[idx] == 'newPosition') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedNewPosition,
                            items: widget.newPositionDropdownItems!
                                .map((position) {
                              return DropdownMenuItem(
                                value: position['position_id']
                                    .toString(), // Store the position_id
                                child: Text(position['position']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedNewPosition = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'New Position',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a position';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] ==
                          'position_change_type' || widget.attributeNames[idx] ==
                          'positionChangeType' ) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedPositionChangeType,
                            items: positionChangeTypes.map((type) {
                              return DropdownMenuItem(
                                value:
                                    type.toLowerCase(), // Send lowercase value
                                child: Text(type), // Display capitalized
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPositionChangeType = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'Position Change Type',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a position change type';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] == 'newSalary') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'New Salary',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a salary';
                              }
                              return null;
                            },
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 1.5,
                              ),
                            ),
                            labelText: widget.attributeNames[idx],
                            labelStyle: GoogleFonts.lato(color: Colors.teal),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all(
                          GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (Form.of(context)?.validate() ?? false) {
                          final values = {
                            for (int i = 0;
                                i < widget.attributeNames.length;
                                i++)
                              widget.attributeNames[i]:
                                  widget.attributeNames[i] == 'oldPhone'
                                      ? selectedOldPhone!
                                      : widget.attributeNames[i] ==
                                              'new_position'
                                          ? selectedNewPosition!
                                          : widget.attributeNames[i] ==
                                                  'position_change_type'
                                              ? selectedPositionChangeType!
                                              : _textControllers[i].text
                          };
                          widget.onSubmit(values);
                        }
                      },
                      child: Text('Submit'),
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

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20); // Adjusted height of the clip path
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
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