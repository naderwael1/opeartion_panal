import 'package:bloc_v2/Features/emp_features/presentation/active_emp_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/custom_tool_bar.dart';
import 'package:bloc_v2/Features/emp_features/presentation/postion_secreen.dart';
import 'package:bloc_v2/add_register/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_v2/add_register/add_register_model.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class AddRegisterEmp extends StatefulWidget {
  const AddRegisterEmp({Key? key}) : super(key: key);

  @override
  State<AddRegisterEmp> createState() => _AddRegisterEmpState();
}

class _AddRegisterEmpState extends State<AddRegisterEmp> {
  TextEditingController ssnNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController statusController = TextEditingController();
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
    ssnNumberController.clear();
    firstNameController.clear();
    lastNameController.clear();
    genderController.clear();
    salaryController.clear();
    statusController.clear();
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
                            top: 20.0), // Padding above the toolbar
                        child: CustomToolBar(titles: const [
                          "Explore",
                          "All Positions",
                          "Attendance",
                          "List of State",
                          "Profile"
                        ], icons: const [
                          Icons.explore,
                          Icons.workspaces,
                          Icons.feed,
                          Icons.quiz_sharp,
                          Icons.person,
                        ], callbacks: [
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PositionListScreen()));
                          },
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PositionListScreen()));
                          },
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PositionListScreen()));
                          },
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ActiveEmployeeScreen()));
                          },
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddPositionScreen()));
                          }
                        ]),
                      ),
                      const Center(
                        child: Text(
                          'Add Employee Registration',
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: ssnNumberController,
                        keyboardType: TextInputType.number,
                        key: const ValueKey('SSN Number'),
                        decoration: inputDecoration.copyWith(
                          labelText: 'SSN Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an SSN Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: firstNameController,
                        key: const ValueKey('First Name'),
                        decoration: inputDecoration.copyWith(
                          labelText: 'First Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: lastNameController,
                        key: const ValueKey('Last Name'),
                        decoration: inputDecoration.copyWith(
                          labelText: 'Last Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: genderController.text.isEmpty
                            ? null
                            : genderController.text,
                        onChanged: (newValue) {
                          setState(() {
                            genderController.text = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'm',
                            child: Text('Male'),
                          ),
                          DropdownMenuItem(
                            value: 'f',
                            child: Text('Female'),
                          ),
                        ],
                        decoration: inputDecoration.copyWith(
                          labelText: 'Gender',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: salaryController,
                        keyboardType: TextInputType.number,
                        key: const ValueKey('Salary'),
                        decoration: inputDecoration.copyWith(
                          labelText: 'Salary',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a salary';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: statusController.text.isEmpty
                            ? null
                            : statusController.text,
                        onChanged: (newValue) {
                          setState(() {
                            statusController.text = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'pending',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: 'active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem(
                            value: 'inactive',
                            child: Text('Inactive'),
                          ),
                        ],
                        decoration: inputDecoration.copyWith(
                          labelText: 'Status',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a status';
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
                                  final addRegisterEmp =
                                      await addregisteremployee(
                                    ssnNumber: ssnNumberController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    gender: genderController.text,
                                    salary: salaryController.text,
                                    status: statusController.text,
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
