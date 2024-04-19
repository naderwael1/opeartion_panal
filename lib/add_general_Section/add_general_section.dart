import 'package:bloc_v2/add_general_Section/add_general_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddGeneralSection extends StatefulWidget {
  const AddGeneralSection({Key? key});

  @override
  State<AddGeneralSection> createState() => _AddGeneralSection();
}

class _AddGeneralSection extends State<AddGeneralSection> {
  TextEditingController sectionNameController = TextEditingController();
  TextEditingController sectionDescriptionController = TextEditingController();


  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    sectionNameController.clear();
    sectionDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add General Section'),
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
                          controller: sectionNameController,
                          maxLength: 80,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                      key: const ValueKey('Section Name'),
                      decoration: const InputDecoration(
                        hintText: 'Section Name',
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
                      controller: sectionDescriptionController,
                      key: const ValueKey('Section Description'),
                          minLines: 5,
                          maxLines: 8,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Section Description',
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
                                final add_general_section = await AddGeneral_Section(
                                  sectionName: sectionNameController.text,
                                  sectionDescription: sectionDescriptionController.text,
                                );
                                print('Adding employee: $add_general_section');
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
