import 'package:bloc_v2/Features/branch_features/Data/add_employe.dart';
import 'package:bloc_v2/add_table/add_table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class addTable extends StatefulWidget {
  const addTable({Key? key});

  @override
  State<addTable> createState() => _addTable();
}

class _addTable extends State<addTable> {
  TextEditingController branchIdController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    branchIdController.clear();
    capacityController.clear();
    statusController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Table'),
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
                      controller: branchIdController,
                      keyboardType: TextInputType.number,
                      key: const ValueKey('branch Id'),
                      decoration: const InputDecoration(
                        hintText: 'branch Id',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter branch Id';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: capacityController,
                      keyboardType: TextInputType.number,
                      key: const ValueKey('ID'),
                      decoration: const InputDecoration(
                        hintText: 'ID',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an ID';
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
                      items: [
                        DropdownMenuItem(
                          value: 'available',
                          child: Text('available'),
                        ),
                        DropdownMenuItem(
                          value: 'booked',
                          child: Text('booked'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: 'status',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
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
                            "Add Table",
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final addTable_Model = await addTableModel(
                                  branchId: branchIdController.text,
                                  capacity: capacityController.text,
                                  status: statusController.text,
                                );
                                print('Adding employee: $addTable_Model');
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
