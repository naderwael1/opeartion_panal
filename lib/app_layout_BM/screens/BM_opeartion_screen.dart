import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BranchMangerOpeartion extends StatefulWidget {
  @override
  _BranchMangerOpeartionState createState() => _BranchMangerOpeartionState();
}

class _BranchMangerOpeartionState extends State<BranchMangerOpeartion> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branch Manager Operation', style: GoogleFonts.lato()),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FunctionInputTile(
                  functionName: 'add-storage',
                  attributeNames: const [
                    'Storage Name',
                    'storageAddress',
                    'managerId'
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for add-storage
                    // Example: PostFunction.addStorage(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'add-menu-item',
                  attributeNames: const [
                    'Item Name',
                    'itemDesc',
                    'Category',
                    'prepTime',
                    'picPath',
                    'vegetarian',
                    'healthy'
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for add-menu-item
                    // Example: PostFunction.addMenuItem(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'add-ingredient',
                  attributeNames: const [
                    'Ingredient Name',
                    'recipeUnit',
                    'shipmentUnit'
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for add-ingredient
                    // Example: PostFunction.addIngredient(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'add_branch_section',
                  attributeNames: const [
                    'Branch Name',
                    'section_id',
                    'manager_id'
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for add_branch_section
                    // Example: PostFunction.addBranchSection(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'addIngredientToStock',
                  attributeNames: const [
                    'branchId',
                    'ingredientId',
                    'ingredientQuantity'
                  ],
                  onSubmit: (values) {
                    // TODO: Call the post function for addIngredientToStock
                    // Example: PostFunction.addIngredientToStock(values);
                  },
                ),
                FunctionInputTile(
                  functionName: 'addItemBranchMenu',
                  attributeNames: const [
                    'branchId',
                    'itemId',
                    'itemPrice',
                    'itemStatus',
                    'itemDiscount'
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
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _textControllers =
        widget.attributeNames.map((_) => TextEditingController()).toList();
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
                style: GoogleFonts.lato(fontSize: 18, color: Colors.teal)),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 1.5,
                              ),
                            ),
                            labelText: widget.attributeNames[idx],
                            labelStyle: GoogleFonts.lato(color: Colors.teal),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
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
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
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
