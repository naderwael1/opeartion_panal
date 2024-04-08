import 'package:bloc_v2/Features/branch_features/Data/add_branch.dart';
import 'package:flutter/material.dart';
import '../data/add_table.dart';
import '../models/table_model.dart'; // Import the TableModel

class AddTableScreen extends StatefulWidget {
  final String branchId;
  final String branchName;

  const AddTableScreen({Key? key, required this.branchId, required this.branchName}) : super(key: key);

  @override
  _AddTableScreenState createState() => _AddTableScreenState();
}

class _AddTableScreenState extends State<AddTableScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String branchId; // Store the branchId passed from the previous screen
  late String capacity;
  late String status;

  @override
  void initState() {
    super.initState();
    branchId = widget.branchId; // Initialize branchId with the value passed from the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Table'),
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
                  decoration: InputDecoration(labelText: 'Branch ID'),
                  initialValue: widget.branchId,
                  readOnly: true,
                ),
                SizedBox(height: 10),
                // Non-editable text field for branch name
                TextFormField(
                  decoration: InputDecoration(labelText: 'Branch Name'),
                  initialValue: widget.branchName,
                  readOnly: true,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Capacity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter capacity';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      capacity = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Status'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter status';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      status = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _AddTable();
                    }
                  },
                  child: Text('Add Table To Branch ${widget.branchName}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _AddTable() async {
    setState(() {

    });
   final TableModel newTableModel = await AddTable().addTable(
     branchId: branchId,
     capacity: capacity,
     status: status,
   );
    // Perform any necessary actions with the new table model, such as saving to a database
    // For now, just print the new table model
    print('New Table: $newTableModel');

    // Optionally, you can navigate back to the previous screen after saving the table
    // Navigator.pop(context);
  }
}
