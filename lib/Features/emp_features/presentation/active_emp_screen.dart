import '../Data/get_active_emp.dart';
import '../models/active_emp_model.dart';
import '../../../Drawer/customDrawer.dart';
import 'package:flutter/material.dart';
import 'custom_active_card.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../../custom_nav_bar.dart';

class ActiveEmployeeScreen extends StatelessWidget {
  const ActiveEmployeeScreen({Key? key});

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
            drawer: const CustomDrawer(),
            bottomNavigationBar: const MyBottomNavigationBar(),
            appBar: AppBar(
              title: const Text('All Employee'),
              actions: const [],
            ),
            body: FutureBuilder<List<ActiveEmployeesModel>>(
              future: GetActiveEmployee().getActiveEmployee(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<ActiveEmployeesModel> employees = snapshot.data!;
                  return GridView.builder(
                    itemCount: employees.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 60,
                    ),
                    itemBuilder: (context, index) {
                      return CustomActiveCard(activeEmployee: employees[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          );
        } else {
          return NoInternetWidget();
        }
      },
      child: const Text('No internet connection'),
    );
  }
}