import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEmployeeVacation extends StatefulWidget {
  const AddEmployeeVacation({Key? key}) : super(key: key);

  @override
  State<AddEmployeeVacation> createState() => _AddEmployeeVacationState();
}

class _AddEmployeeVacationState extends State<AddEmployeeVacation> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController vacationStartDateController = TextEditingController();
  TextEditingController vacationReasonController = TextEditingController();
  TextEditingController vacationEndDateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void clearForm() {
    employeeIdController.clear();
    vacationStartDateController.clear();
    vacationReasonController.clear();
    vacationEndDateController.clear();
  }

  void submitVacationRequest() {
    if (_formKey.currentState!.validate()) {
      print(
          "Vacation request submitted for Employee ID ${employeeIdController.text}");
      // Submit logic here
      clearForm();
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
                  height: 150,
                  color:
                      Color(0xFF00897B), // Adjusted to match your desired color
                  child: Center(
                    child: Text(
                      'Employee Registration',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                    children: <Widget>[
                      TextFormField(
                        controller: employeeIdController,
                        decoration: InputDecoration(
                          labelText: 'Employee ID',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the employee ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: vacationStartDateController,
                        decoration: InputDecoration(
                          labelText: 'Vacation Start Date',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the start date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: vacationReasonController,
                        decoration: InputDecoration(
                          labelText: 'Reason for Vacation',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reason for the vacation';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: clearForm,
                            child: Text('Clear'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red, // foreground
                            ),
                          ),
                          ElevatedButton(
                            onPressed: submitVacationRequest,
                            child: Text('Submit'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green, // foreground
                            ),
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
