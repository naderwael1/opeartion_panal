import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/edit_upload_product_form.dart';
import 'package:bloc_v2/add_general_Section/add_general_section.dart';
import 'package:bloc_v2/add_register/add_register_employee.dart';
import 'package:bloc_v2/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Drawer/customDrawer.dart';
import '../../../../../constants.dart';
import '../../../../branch_features/presentation/all_braches_screen.dart';
import 'custom_category_card.dart';

class HomeBody extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Mat3m 7baib Elsaida'),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(
                  themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(themeProvider.getIsDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildCard(context, 'HR Dept', hrImage, const AllEmployeeScreen()),
          _buildCard(context, 'Operation Manager', operationImage, const AllBranchScreen()),
          _buildCard(context, 'Branch Manager', mangerImage, const AllBranchScreen()),
          _buildCard(context, 'Storage', storgeImage, const AllBranchScreen()),
          _buildCard(context, 'Upload', cloud, const EditOrUploadProductScreen()),
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
