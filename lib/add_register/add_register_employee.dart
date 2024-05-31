import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_v2/Features/emp_features/presentation/hrFlashy_tab_bar.dart';
import 'package:bloc_v2/add_register/add_register_model.dart';

class AddRegisterEmp extends StatefulWidget {
  const AddRegisterEmp({Key? key}) : super(key: key);

  @override
  State<AddRegisterEmp> createState() => _AddRegisterEmp();
}

class _AddRegisterEmp extends State<AddRegisterEmp> {
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
        bottomNavigationBar: HrFlashyTabBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onTabSelected,
        ),
        appBar: AppBar(
          title: const Text('Add Employee Registration'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: ssnNumberController,
                      keyboardType: TextInputType.number,
                      key: const ValueKey('SSN Number'),
                      decoration: const InputDecoration(
                        hintText: 'SSN Number',
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
                      decoration: const InputDecoration(
                        hintText: 'First Name',
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
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
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
                      decoration: const InputDecoration(
                        hintText: 'Gender',
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: salaryController,
                      keyboardType: TextInputType.number,
                      key: const ValueKey('Salary'),
                      decoration: const InputDecoration(
                        hintText: 'Salary',
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
                      decoration: const InputDecoration(
                        hintText: 'Status',
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
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.clear),
                          label: const Text(
                            "Clear",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: clearForm,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.upload),
                          label: const Text(
                            "Add Register Employee",
                          ),
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
                                clearForm();
                              } catch (e) {
                                print('Error adding employee: $e');
                              }
                            } else {
                              print('Form is not valid');
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
