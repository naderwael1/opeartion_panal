import 'package:bloc_v2/Features/edit_data_employee/edit_data_employee_model.dart';
import 'package:flutter/material.dart';
import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/add_register/style.dart';
import 'package:flutter/services.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

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
    employeeIdController.clear();
    changerIdController.clear();
    newSalaryController.clear();
    changeReasonController.clear();
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
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
                          child: Text('operation manager'),
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: newSalaryController,
                      keyboardType: TextInputType.number,
                      key: const ValueKey('New Salary'),
                      decoration: inputDecoration.copyWith(
                        labelText: 'New Salary',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an New Salary';
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
                          onPressed: clearForm,
                        ),
                        ElevatedButton.icon(
                          style: elevatedButtonStyle,
                          icon: const Icon(Icons.upload),
                          label: const Text("Add Register Employee"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final editedEmployee  =
                                    await editSaleryEmployee(
                                  employeeId: widget.employeeId,
                                  changerId: changerIdController.text,
                                  newSalary: newSalaryController.text,
                                  changeReason: changeReasonController.text,
                                );
                                print('Edit salary employee: $editedEmployee');
                                CherryToast.success(
                                  animationType: AnimationType.fromRight,
                                  toastPosition: Position.bottom,
                                  description: const Text(
                                    "Edit salary successfully",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ).show(context);
                                clearForm();
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
