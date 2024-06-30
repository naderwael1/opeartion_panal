import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRegisterEmp extends StatefulWidget {
  const AddRegisterEmp({Key? key}) : super(key: key);

  @override
  State<AddRegisterEmp> createState() => _AddRegisterEmpState();
}

class _AddRegisterEmpState extends State<AddRegisterEmp> {
  final TextEditingController ssnNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController positionIdController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController branchIdController = TextEditingController();
  final TextEditingController sectionIdController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateHiredController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                height: 200,
                color: Colors.teal,
                alignment: Alignment.center,
                child: Text(
                  'Employee Registration',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: ssnNumberController,
                      decoration: InputDecoration(
                        labelText: 'SSN Number',
                        prefixIcon: Icon(Icons.security),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            14), // Limit to 14 digits
                      ],
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 14) {
                          return 'SSN must be exactly 14 digits';
                        }
                        return null;
                      },
                    ),
                    buildTextFormField(
                        firstNameController, 'First Name', Icons.person),
                    buildTextFormField(
                        lastNameController, 'Last Name', Icons.person_outline),
                    buildDropdownField(
                        genderController, 'Gender', ['Male', 'Female']),
                    buildTextFormField(
                        salaryController, 'Salary', Icons.monetization_on,
                        isNumeric: true),
                    buildTextFormField(
                        positionIdController, 'Position ID', Icons.work),
                    buildDropdownField(statusController, 'Status',
                        ['Active', 'Inactive', 'Pending']),
                    buildTextFormField(
                        branchIdController, 'Branch ID', Icons.business),
                    buildTextFormField(
                        sectionIdController, 'Section ID', Icons.dashboard),
                    buildDateField(birthDateController, 'Birth Date'),
                    buildTextFormField(
                        addressController, 'Address', Icons.home),
                    buildDateField(dateHiredController, 'Date Hired'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Process data
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Register'),
                          ),
                          ElevatedButton(
                            onPressed: clearForm,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
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

  Widget buildTextFormField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDropdownField(
      TextEditingController controller, String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: controller.text.isEmpty ? null : controller.text,
        onChanged: (newValue) {
          setState(() {
            controller.text = newValue!;
          });
        },
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.arrow_drop_down_circle),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: () => selectDate(controller, label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  void selectDate(TextEditingController controller, String label) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void clearForm() {
    ssnNumberController.clear();
    firstNameController.clear();
    lastNameController.clear();
    genderController.clear();
    salaryController.clear();
    positionIdController.clear();
    statusController.clear();
    branchIdController.clear();
    sectionIdController.clear();
    birthDateController.clear();
    dateHiredController.clear();
    addressController.clear();
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
