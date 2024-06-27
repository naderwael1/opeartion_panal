import 'package:bloc_v2/Features/branch_features/presentation/employeesAttendance_screen.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/new_login_screen.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/profile_screen.dart';
import 'package:bloc_v2/Features/operation_manger/app_layout_operation.dart';
import 'package:bloc_v2/add_general_Section/add_general_section.dart';
import 'package:bloc_v2/app_layout/screens/app_layout_screen.dart';
import 'package:bloc_v2/app_layout_BM/screens/app_layout_screen.dart';
import 'package:bloc_v2/pdf/page/pdf_page.dart';
import 'package:bloc_v2/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Drawer/customDrawer.dart';
import '../../../../../constants.dart';
import 'custom_category_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.off(() => const LoginScreenNew());
  }

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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildCard(context, 'HR Dept', hrImage, const AppLayoutScreen()),
          _buildCard(context, 'Operation Manager', operationImage,
              const OpearationMangerLayout()),
          _buildCard(context, 'Branch Manager', mangerImage,
              const AppLayoutScreenBM()),
          _buildCard(
              context, 'Storage', storgeImage, const EmpAttendanceScreen()),
          _buildCard(context, 'Upload', cloud, const PdfPage()), // add menu item (EditOrUploadProductScreen)
          _buildCard(context, 'table', table, const ProfileScreen()), // (AddGeneralSection)
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
