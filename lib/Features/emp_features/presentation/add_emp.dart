import 'package:flutter/material.dart';

class AddEmp extends StatelessWidget {
  const AddEmp({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar( // Add AppBar here
          title: Text('Add Employee'), // Set app bar title
          // You can add more properties like leading, actions, etc. as needed
        ),
        body: const Column(
          children: [],
        ),
      ),
    );
  }
}
