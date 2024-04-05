import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Drawer/customDrawer.dart';
import '../../../Drawer/drawerArt.dart';
import '../../../core/utils/theme.dart';
import '../Data/get_all_emp_list.dart';
import 'add_emp.dart';
import 'custom_card.dart';

class AllEmployeeScreen extends StatelessWidget {
  const AllEmployeeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Your Screen Title'),
        actions: [
          const ThemeToggleWidget(), //
        ],
      ),
      body: FutureBuilder<List<EmployeeModel>>(
        future: GetAllEmployee().getAllProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<EmployeeModel> employees = snapshot.data!;
            return GridView.builder(
              itemCount: employees.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 60,
              ),
              itemBuilder: (context, index) {
                return CustomCard(employee: employees[index]);
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmp()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
