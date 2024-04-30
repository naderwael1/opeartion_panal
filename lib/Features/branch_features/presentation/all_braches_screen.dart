import 'package:bloc_v2/Features/branch_features/presentation/category_screen.dart';
import 'package:bloc_v2/Features/branch_features/presentation/recipes_screeen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/custom_tool_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../../core/utils/theme.dart';
import '../../../Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';
import '../../../Drawer/customDrawer.dart';
import '../Data/get_all_branchs.dart';

import 'add_branch_screen.dart';
import 'custom_branch_card.dart';

class AllBranchScreen extends StatelessWidget {
  const AllBranchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return connected
            ? buildConnectedScreen(context)
            : NoInternetWidget(context); // Pass context here
      },
      child: const Text('No internet connection'),
    );
  }

  void goFirstScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllBranchScreen()),
    );
  }

  Widget NoInternetWidget(BuildContext context) {
    // Accept context as a parameter
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/undraw_bug_fixing_oc7a.png',
                  height: 200), // Ensure the path to your asset is correct
              const SizedBox(height: 40),
              const Text(
                'Oops! No Internet Connection.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Please check your network settings and try again.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Implement retry logic
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConnectedScreen(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('All Branches'),
        centerTitle: true,
        actions: const [
          ThemeToggleWidget(),
        ],
      ),
      body: Column(
        children: [
          CustomToolBar(titles: const [
            "All Branches",
            "Kitchen Category",
            "recipe Item"
          ], icons: const [
            Icons.home,
            Icons.category,
            Icons.food_bank,
          ], callbacks: [
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllBranchScreen()));
            },
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen()));
            },
            () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecipesList(2)));
            },
          ]),
          Expanded(
            child: FutureBuilder<List<BranchModel>>(
              future: GetAllBranches().getAllBranches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBranchScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
