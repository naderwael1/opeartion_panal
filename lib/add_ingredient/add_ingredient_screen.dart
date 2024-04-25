import 'package:bloc_v2/add_ingredient/add_ingredient_model.dart';
import 'package:bloc_v2/consts/validator.dart';
import 'package:flutter/material.dart';

class AddIngredient extends StatefulWidget {
  const AddIngredient({Key? key});

  @override
  State<AddIngredient> createState() => _AddIngredient();
}

class _AddIngredient extends State<AddIngredient> {
  TextEditingController nameController = TextEditingController();
  TextEditingController recipeUnitController = TextEditingController();
  TextEditingController shipmentUnitController = TextEditingController();

  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    nameController.clear();
    recipeUnitController.clear();
    shipmentUnitController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Ingredient'),
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
                      controller: nameController,
                      maxLength: 80,
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                      ),
                      validator: (value) {
                        return MyValidators.uploadProdTexts(
                          value: value,
                          toBeReturnedString: "Please Enter Name",
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: recipeUnitController.text.isEmpty
                          ? null
                          : recipeUnitController.text,
                      onChanged: (newValue) {
                        setState(() {
                          recipeUnitController.text = newValue!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'gram',
                          child: Text('gram'),
                        ),
                        DropdownMenuItem(
                          value: 'kilogram',
                          child: Text('kilogram'),
                        ),
                        DropdownMenuItem(
                          value: 'liter',
                          child: Text('liter'),
                        ),
                        DropdownMenuItem(
                          value: 'milliliter',
                          child: Text('milliliter'),
                        ),
                        DropdownMenuItem(
                          value: 'piece',
                          child: Text('piece'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Recipe Unit',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Recipe Unit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                                        DropdownButtonFormField<String>(
                      value: shipmentUnitController.text.isEmpty
                          ? null
                          : shipmentUnitController.text,
                      onChanged: (newValue) {
                        setState(() {
                          shipmentUnitController.text = newValue!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'gram',
                          child: Text('gram'),
                        ),
                        DropdownMenuItem(
                          value: 'kilogram',
                          child: Text('kilogram'),
                        ),
                        DropdownMenuItem(
                          value: 'liter',
                          child: Text('liter'),
                        ),
                        DropdownMenuItem(
                          value: 'milliliter',
                          child: Text('milliliter'),
                        ),
                        DropdownMenuItem(
                          value: 'piece',
                          child: Text('piece'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Recipe Unit',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Recipe Unit';
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
                            "ADD Ingredient",
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final addStorageModel =
                                    await addIngredient_model(
                                  name: nameController.text,
                                  recipeUnit: recipeUnitController.text,
                                  shipmentUnit: shipmentUnitController.text,
                                );
                                print('Adding employee: $addStorageModel');
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
