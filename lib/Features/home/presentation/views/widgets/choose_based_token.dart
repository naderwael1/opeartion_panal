import 'package:bloc_v2/Features/branch_features/presentation/employeesAttendance_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/edit_upload_product_form.dart';
import 'package:bloc_v2/add_general_Section/add_general_section.dart';
import 'package:bloc_v2/add_ingredient/add_ingredient_screen.dart';
import 'package:bloc_v2/add_register/add_register_employee.dart';
import 'package:bloc_v2/add_storage/add_storage_screen.dart';
import 'package:bloc_v2/add_table/add_table_screen.dart';
import 'package:bloc_v2/app_layout/screens/app_layout_screen.dart';
import 'package:bloc_v2/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Drawer/customDrawer.dart';
import '../../../../../constants.dart';
import '../../../../branch_features/presentation/all_braches_screen.dart';
import 'custom_category_card.dart';
import 'package:bloc_v2/spincircle.dart';
import 'package:bloc_v2/spincircle2.dart';

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
          _buildCard(context, 'HR Dept', hrImage, const AppLayoutScreen()),
          _buildCard(context, 'Operation Manager', operationImage,
              const AllBranchScreen()),
          _buildCard(
              context, 'Branch Manager', mangerImage, const AddRegisterEmp()),
          _buildCard(
              context, 'Storage', storgeImage, const EmpAttendanceScreen()),
          _buildCard(context, 'Upload', cloud,
              const AddStorage()), // add menu item (EditOrUploadProductScreen)
          _buildCard(context, 'table', table,
              const AddStorage()), // (AddGeneralSection)
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String text, String photoUrl,
      Widget destinationScreen) {
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
