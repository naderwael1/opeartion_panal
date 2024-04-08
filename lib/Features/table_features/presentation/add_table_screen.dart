import 'package:flutter/material.dart';
import '../data/add_table.dart';
import '../models/table_model.dart';

class AddTableScreen extends StatefulWidget {
  final String branchId;
  final String branchName;

  const AddTableScreen({Key? key, required this.branchId, required this.branchName}) : super(key: key);

  @override
  _AddTableScreenState createState() => _AddTableScreenState();
}

class _AddTableScreenState extends State<AddTableScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String branchId;
  late String status;
  int numberOfTables = 1; // Default number of tables to add
  String capacity = ''; // Store capacity entered by the user

  @override
  void initState() {
    super.initState();
    branchId = widget.branchId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Add Table & Sections')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Branch Name'),
                  initialValue: widget.branchName,
                  readOnly: true,
                ),
                SizedBox(height: 10),
                Row( // Row for Number of Tables and Capacity
                  children: [
                    Expanded( // Flexible widget to take available space
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Number of Tables'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            numberOfTables = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10), // Spacer between the fields
                    Expanded( // Flexible widget to take available space
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Capacity'),
                        keyboardType: TextInputType.number,

                        onChanged: (value) {
                          setState(() {
                            capacity = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Status'),
                  readOnly: true,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter status';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      status = 'available';
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addTables();
                    }
                  },
                  child: Text('Add Tables'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addTables() async {
    for (int i = 0; i < numberOfTables; i++) {
      final TableModel newTableModel = await AddTable().addTable(
        branchId: branchId,
        capacity: capacity,
        status: status,
      );
      print('New Table ${i + 1}: $newTableModel');
    }
  }
}
