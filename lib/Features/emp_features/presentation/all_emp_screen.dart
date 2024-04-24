import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Drawer/customDrawer.dart';
import '../../../Drawer/sidebarx.dart';
import '../../../core/utils/theme.dart';
import '../../../custom_nav_bar.dart';
import '../Data/get_all_emp_list.dart';
import 'add_emp.dart';
import 'custom_card.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'custom_tool_bar.dart';

class AllEmployeeScreen extends StatelessWidget {
  const AllEmployeeScreen({Key? key}) : super(key: key);

  Widget NoInternetWidget() {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            const Text(
              'Can\'t connect to the internet. Please check your connection',
              style: TextStyle(fontSize: 22),
            ),
            Image.asset('assets/images/undraw_bug_fixing_oc7a.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connected) {
          return Scaffold(
            drawer: const sideBarHR(),
            appBar: AppBar(
              title: const Text('All Employee'),
              actions: const [
                ThemeToggleWidget(),
              ],
            ),
            body: FutureBuilder<List<EmployeeModel>>(
              future: GetAllEmployee().getAllProduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<EmployeeModel> employees = snapshot.data!;
                  return GridView.builder(
                    itemCount: employees.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 60,
                    ),
                    itemBuilder: (context, index) {
                      return CustomCard(employee: employees[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
            bottomNavigationBar:
                CustomToolBar(), // Add your custom toolbar here
          );
        } else {
          return NoInternetWidget();
        }
      },
      child: const Text('No internet connection'),
    );
  }
}
