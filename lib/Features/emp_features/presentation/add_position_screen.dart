import 'package:flutter/material.dart';
import '../Data/add_position.dart'; // Import the function for adding a position

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Position'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: positionNameController,
              decoration: InputDecoration(labelText: 'Position Name'),
            ),
            TextField(
              controller: jobDescriptionController,
              decoration: InputDecoration(labelText: 'Job Description'),
            ),
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
    );
  }
}
