import 'package:flutter/material.dart';
import 'package:bloc_v2/core/utils/helper/api_helper.dart';
import '../Data/add_branch.dart';
import '../models/branch_model.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({Key? key}) : super(key: key);

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddBranchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String branchName = '';
  String branchAddress = '';
  String branchLocation = '';
  String coverage = '';
  String branchPhone = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Branch'),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter branch name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      branchName = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Branch Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter branch address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      branchAddress = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Branch Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter branch location';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      branchLocation = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Coverage'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter coverage';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      coverage = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Branch Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter branch phone';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      branchPhone = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addBranch();
                    }
                  },
                  child: Text('Add Branch'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addBranch() async {
    setState(() {
      isLoading = true;
    });

    try {
      final BranchModel branch = await AddBranch().addBranch(
        branchName: branchName,
        branchAddress: branchAddress,
        branchLocation: branchLocation,
        coverage: coverage,
        branchPhone: branchPhone,
      );

      // Handle successful branch addition
      print('Branch added: $branch');
    } catch (e) {
      // Handle error
      print('Error adding branch: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
