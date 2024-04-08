import 'package:flutter/material.dart';
import '../../branch_features/Data/get_all_branchs.dart';
import '../../branch_features/models/branch_model.dart';
import '../Data/add_position.dart'; // Import the function for adding a position
import 'custom_dropdown.dart';

class AddPositionScreen extends StatefulWidget {
  const AddPositionScreen({Key? key}) : super(key: key);

  @override
  _AddPositionScreenState createState() => _AddPositionScreenState();
}

class _AddPositionScreenState extends State<AddPositionScreen> {
  TextEditingController positionNameController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String? selectedBranch;
  List<BranchModel> branches = []; // List to hold the fetched branches

  @override
  void initState() {
    super.initState();
    fetchBranches(); // Fetch branches when the screen initializes
  }

  // Method to fetch all branches
  void fetchBranches() async {
    try {
      final getAllBranches = GetAllBranches();
      List<BranchModel> fetchedBranches = await getAllBranches.getAllBranches();
      setState(() {
        branches = fetchedBranches;
        if (branches.isNotEmpty) {
          selectedBranch = branches[0].branchName; // Select the first branch by default
        }
      });
    } catch (e) {
      print('Error fetching branches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Position'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: positionNameController,
                decoration: InputDecoration(labelText: 'Position Name'),
              ),
              TextFormField(
                controller: jobDescriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
              ),
              SizedBox(height: 16.0),
              buildDropdownMenu('Select Branch', selectedBranch, branches.map((branch) => branch.branchName).toList(), (value) {
                setState(() {
                  selectedBranch = value;
                });
              }),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Call the addPosition function with the required parameters
                    final positionId = await addPosition(
                      positionName: positionNameController.text,
                      jobDescription: jobDescriptionController.text,
                    );

                    // Optionally, you can handle the response here if needed

                    // Navigate to another screen or perform other actions after adding the position
                  } catch (e) {
                    print('Error adding position: $e');
                    // Handle error
                  }
                },
                child: Text('Add Position'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
