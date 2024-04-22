import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'Features/emp_features/presentation/add_emp.dart';
import 'Features/emp_features/presentation/add_position_screen.dart';
import 'Features/emp_features/presentation/all_emp_screen.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Iconsax.home), label: 'Employee'),
        NavigationDestination(
            icon: Icon(Icons.person_add_alt), label: 'Add Employee'),
        NavigationDestination(icon: Icon(Icons.work), label: 'Add Position'),
      ],
      height: 60,
      backgroundColor: Color(0xff100B20),
      onDestinationSelected: (index) {
        // Handle navigation here based on the selected index
        // You can use Navigator to navigate to different screens
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEmp()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEmp()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPositionScreen()),
            );
            break;
        }
      },
    );
  }
}
