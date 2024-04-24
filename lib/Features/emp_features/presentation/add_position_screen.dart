import 'package:bloc_v2/Features/emp_features/Data/add_position.dart';
import 'package:bloc_v2/add_general_Section/add_general_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class AddPositionScreen extends StatefulWidget {
  const AddPositionScreen({Key? key});

  @override
  State<AddPositionScreen> createState() => _AddPositionScreen();
} //

class _AddPositionScreen extends State<AddPositionScreen> {
  TextEditingController positionNameController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();

  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    positionNameController.clear();
    jobDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Add Position'),
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
                      controller: positionNameController,
                      maxLength: 80,
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      key: const ValueKey('position name'),
                      decoration: const InputDecoration(
                        hintText: 'Position Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Enter section name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: jobDescriptionController,
                      key: const ValueKey('Job Description'),
                      minLines: 5,
                      maxLines: 8,
                      maxLength: 1000,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Job Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Enter Section Description';
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
                          onPressed: () {
                            clearForm();
                          },
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
                            "ADD General Section",
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final addPositionNameAndDescription =
                                    await addPosition(
                                  positionName: positionNameController.text,
                                  jopdescription: jobDescriptionController.text,
                                );
                                print(
                                    'Adding employee: $addPositionNameAndDescription');
                                CherryToast.success(
                                  animationType: AnimationType.fromRight,
                                  toastPosition: Position.bottom,
                                  description: const Text(
                                    "CherryToast Displayed sucessfully",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ).show(context);
                                clearForm();
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

                                print('Error adding employee: $e');
                              }
                            } else {
                              CherryToast.warning(
                                toastPosition: Position.bottom,
                                animationType: AnimationType.fromLeft,
                                description: const Text(
                                  "Data is Not Valid or not complete ",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ).show(context);
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
