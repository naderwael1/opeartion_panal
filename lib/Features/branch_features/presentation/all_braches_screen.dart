import 'package:bloc_v2/Features/branch_features/presentation/category_screen.dart';
import 'package:bloc_v2/Features/branch_features/presentation/recipes_screeen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/custom_tool_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_v2/Features/branch_features/Data/get_all_branchs.dart';
import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';
import 'package:bloc_v2/Features/branch_features/presentation/custom_branch_card.dart';

class AllBranchScreen extends StatefulWidget {
  const AllBranchScreen({Key? key}) : super(key: key);

  @override
  _AllBranchScreenState createState() => _AllBranchScreenState();
}

class _AllBranchScreenState extends State<AllBranchScreen> {
  List<BranchModel>? branches;
  BranchModel? selectedBranch;

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    try {
      branches = await GetAllBranches().getAllBranches();
      setState(() {
        selectedBranch = branches?.first;
      });
    } catch (e) {
      print('Failed to fetch branches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Branches', style: GoogleFonts.openSans()),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Placeholder for search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CustomToolBar(
            titles: const ['All Branches', 'Kitchen Category', 'Recipe Item'],
            icons: const [Icons.home, Icons.category, Icons.food_bank],
            callbacks: [
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllBranchScreen())),
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen())),
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipesList(
                            2,
                            iD: 2,
                          ))), // Corrected here
            ],
          ),
          Expanded(
            child: branches == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: branches!.length,
                    itemBuilder: (context, index) {
                      return CustomCard(branch: branches![index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
