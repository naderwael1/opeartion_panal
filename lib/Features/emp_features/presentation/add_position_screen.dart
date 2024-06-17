import 'package:bloc_v2/Features/emp_features/Data/add_position.dart';
import 'package:bloc_v2/add_register/style.dart';
import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class AddPositionScreen extends StatefulWidget {
  const AddPositionScreen({Key? key});

  @override
  State<AddPositionScreen> createState() => _AddPositionScreenState();
}

class _AddPositionScreenState extends State<AddPositionScreen> {
  TextEditingController positionNameController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    positionNameController.clear();
    jobDescriptionController.clear();
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
                  child: const Center(
                    child: Text(
                      'Add New Job Position',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                        controller: positionNameController,
                        maxLength: 80,
                        minLines: 1,
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        key: const ValueKey('position name'),
                        decoration: inputDecoration.copyWith(
                          labelText: 'Position Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a position name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: jobDescriptionController,
                        key: const ValueKey('Job Description'),
                        minLines: 5,
                        maxLines: 8,
                        maxLength: 1000,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Job Description',
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
                            onPressed: () {
                              clearForm();
                            },
                          ),
                          ElevatedButton.icon(
                            style: elevatedButtonStyle,
                            icon: const Icon(Icons.upload),
                            label: const Text("Add Position"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final addPositionNameAndDescription =
                                      await addPosition(
                                    positionName: positionNameController.text,
                                    jopdescription:
                                        jobDescriptionController.text,
                                  );
                                  CherryToast.success(
                                    animationType: AnimationType.fromRight,
                                    toastPosition: Position.bottom,
                                    description: const Text(
                                      "Position added successfully",
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
