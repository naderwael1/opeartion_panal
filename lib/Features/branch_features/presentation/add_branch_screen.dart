import 'package:flutter/material.dart';
import '../../table_features/presentation/add_table_screen.dart';
import '../Data/add_branch.dart';
import '../models/branch_model.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({Key? key}) : super(key: key);

  @override
  _AddBranchScreenState createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  TextEditingController branchNameController = TextEditingController();
  TextEditingController branchAddressController = TextEditingController();
  TextEditingController branchLocationController = TextEditingController();
  TextEditingController coverageController = TextEditingController();
  TextEditingController branchPhoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Branch'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: branchNameController,
              decoration: InputDecoration(labelText: 'Branch Name'),
            ),
            TextField(
              controller: branchAddressController,
              decoration: InputDecoration(labelText: 'Branch Address'),
            ),
            TextField(
              controller: branchLocationController,
              decoration: InputDecoration(labelText: 'Branch Location'),
            ),
            TextField(
              controller: coverageController,
              decoration: InputDecoration(labelText: 'Coverage'),
            ),
            TextField(
              controller: branchPhoneController,
              decoration: InputDecoration(labelText: 'Branch Phone'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Call the addBranch function with the required parameters
                  final branchId = await addBranch(
                    branchName: branchNameController.text,
                    branchAddress: branchAddressController.text,
                    branchLocation: branchLocationController.text,
                    coverage: coverageController.text,
                    branchPhone: branchPhoneController.text,
                  );

                  // Navigate to AddTableScreen after adding branch
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTableScreen(
                        branchId: branchId,
                        branchName: branchNameController.text,
                      ),
                    ),
                  );
                } catch (e) {
                  print('Error adding branch: $e');
                  // Handle error
                }
              },

              child: Text('Add Branch'),
            ),
          ],
        ),
      ),
    );
  }
}
