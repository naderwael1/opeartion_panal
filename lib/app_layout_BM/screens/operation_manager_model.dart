import 'package:bloc_v2/all_model_operation_manager/add_branch_model.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OperationManagerRole extends StatefulWidget {
  @override
  _OperationManagerRole createState() => _OperationManagerRole();
}

class _OperationManagerRole extends State<OperationManagerRole> {
  final _formKey = GlobalKey<FormState>();

  void clearFormFields() {
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operation Manager', style: GoogleFonts.lato()),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FunctionInputTile(
                  functionName: 'Add New Branch',
                  attributeNames: const [
                    'branchName',
                    'branchAddress',
                    'branchLocation',
                    'coverage',
                    'branchPhone',
                    'manager_id'
                  ],
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await addBranchModel(
                          branchName: values['branchName']!,
                          branchAddress: values['branchAddress']!,
                          branchLocation: values['branchLocation']!,
                          coverage: values['coverage']!,
                          branchPhone: values['branchPhone']!,
                          manager_id: values['manager_id']!,
                        );
                        print('Adding Storage: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Add Storage successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error adding storage: $e');
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
                      print('Form is not valid');
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
                FunctionInputTile(
                  functionName: 'Add General Section',
                  attributeNames: const [
                    'section_name',
                    'section_description',
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for add-menu-item
                    // Example: PostFunction.addMenuItem(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'Recipe',
                  attributeNames: const [
                    'itemId',
                    'ingredientId',
                    'quantity',
                    'recipeStatus'
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for add-ingredient
                    // Example: PostFunction.addIngredient(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'Item By Season',
                  attributeNames: const ['itemId', 'seasonId'],
                  onSubmit: (values) {
                    // TODO: Call the post function for add_branch_section
                    // Example: PostFunction.addBranchSection(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'Item By Time',
                  attributeNames: const [
                    'itemId',
                    'itemDayType',
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for addIngredientToStock
                    // Example: PostFunction.addIngredientToStock(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'Season',
                  attributeNames: const [
                    'seasonName',
                    'seasonDesc',
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for addItemBranchMenu
                    // Example: PostFunction.addItemBranchMenu(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'Category',
                  attributeNames: const [
                    'sectionId',
                    'categoryName',
                    'categoryDescription'
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for addItemBranchMenu
                    // Example: PostFunction.addItemBranchMenu(values);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FunctionInputTile extends StatefulWidget {
  final String functionName;
  final List<String> attributeNames;
  final void Function(Map<String, String> values) onSubmit;

  FunctionInputTile({
    required this.functionName,
    required this.attributeNames,
    required this.onSubmit,
  });

  @override
  _FunctionInputTileState createState() => _FunctionInputTileState();
}

class _FunctionInputTileState extends State<FunctionInputTile> {
  late List<TextEditingController> _textControllers;
  late Future<List<Map<String, dynamic>>> _managerListFuture;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _textControllers =
        widget.attributeNames.map((_) => TextEditingController()).toList();
    if (widget.functionName == 'Add New Branch') {
      _managerListFuture = fetchManagerList();
    }
  }

  Future<List<Map<String, dynamic>>> fetchManagerList() async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1:4000/admin/employees/manager-employees-list'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load manager list');
    }
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ClipPath(
        clipper: MyCustomClipper(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            title: Text(widget.functionName,
                style: GoogleFonts.lato(fontSize: 18, color: Colors.blue)),
            onExpansionChanged: (expanded) {
              _toggleExpand();
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ..._textControllers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      TextEditingController controller = entry.value;

                      if (widget.attributeNames[idx] == 'coverage') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              labelText: widget.attributeNames[idx],
                              labelStyle: GoogleFonts.lato(color: Colors.blue),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                          ),
                        );
                      }

                      if (widget.attributeNames[idx] == 'manager_id') {
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: _managerListFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final managerList = snapshot.data!;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                    ),
                                    labelText: 'Manager',
                                    labelStyle:
                                        GoogleFonts.lato(color: Colors.blue),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  items: managerList.map((manager) {
                                    return DropdownMenuItem<int>(
                                      value: manager['id'],
                                      child: Text(manager['name']),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    _textControllers[idx].text =
                                        value.toString();
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a manager';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            }
                          },
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            labelText: widget.attributeNames[idx],
                            labelStyle: GoogleFonts.lato(color: Colors.blue),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all(
                          GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (Form.of(context)?.validate() ?? false) {
                          final values = {
                            for (int i = 0;
                                i < widget.attributeNames.length;
                                i++)
                              widget.attributeNames[i]: _textControllers[i].text
                          };
                          // Call the onSubmit function with the form values
                          widget.onSubmit(values);

                          // TODO: Call the post function for each specific use case here.
                          // For example: PostFunction.addStorage(values);
                          // Your partner should implement the PostFunction class with appropriate methods to handle the data submission.
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20); // Adjusted height of the clip path
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
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