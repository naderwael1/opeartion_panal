import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Drawer/customDrawer.dart';
import '../../../Drawer/drawerArt.dart';
import '../Data/get_all_branchs.dart';

import 'custom_branch_card.dart';

class AllBranchScreen extends StatelessWidget {
  const AllBranchScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('All Branches'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Handle onPressed action here
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<BranchModel>>(
        future: GetAllBranches().getAllBranches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<BranchModel> branches = snapshot.data!;
            return ListView.builder(
              itemCount: branches.length,
              itemBuilder: (context, index) {
                return CustomCard(branch: branches[index]);
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
