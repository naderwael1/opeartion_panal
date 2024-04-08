import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../Drawer/customDrawer.dart';
import '../../../../../constants.dart';
import '../../../../branch_features/presentation/all_braches_screen.dart';
import 'custom_category_card.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Mat3m 7baib Elsaida'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildCard(context, 'HR Dept', hrImage, const AllEmployeeScreen()),
          _buildCard(context, 'Operation Manager', operationImage, const AllBranchScreen()),
          _buildCard(context, 'Branch Manager', mangerImage, const AllBranchScreen()),
          _buildCard(context, 'Storage', storgeImage, const AllBranchScreen()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String text, String photoUrl, Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: CustomCard(
        text: text,
        photoUrl: photoUrl,
      ),
    );
  }
}
