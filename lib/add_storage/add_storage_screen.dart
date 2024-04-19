import 'package:bloc_v2/add_storage/add_storage_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddStorage extends StatefulWidget {
  const AddStorage({Key? key});

  @override
  State<AddStorage> createState() => _AddStorage();
}

class _AddStorage extends State<AddStorage> {
  TextEditingController storageNameController = TextEditingController();
  TextEditingController storageAddressController = TextEditingController();
  TextEditingController managerIdController = TextEditingController();

  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    storageNameController.clear();
    storageAddressController.clear();
    managerIdController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Storage'),
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
                      controller: storageNameController,
                      key: const ValueKey('storage Name'),
                      decoration: const InputDecoration(
                        hintText: 'storage Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an storage Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: storageAddressController,
                      key: const ValueKey('storage Address'),
                      decoration: const InputDecoration(
                        hintText: 'storageAddress',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Enter storage Address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: managerIdController,
                      key: const ValueKey('manager Id'),
                      decoration: const InputDecoration(
                        hintText: 'manager Id',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Enter manager Id';
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
                            "ADD Storage",
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final addStorage_Model =
                                    await addStorageModel(
                                  storageName: storageNameController.text,
                                  storageAddress: storageAddressController.text,
                                  managerId: managerIdController.text,
                                );
                                print('Adding employee: $addStorage_Model');
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