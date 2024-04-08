import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Iconsax.home), label: 'Employee'),
        NavigationDestination(icon: Icon(Iconsax.add_circle), label: 'Add Employee'),
        NavigationDestination(icon: Icon(Icons.home), label: 'Add Position'),
      ],
      height: 60,
      backgroundColor: Color(0xff100B20),
      onDestinationSelected: (index) {
        // Handle navigation here based on the selected index
        // You can use Navigator to navigate to different screens
        switch (index) {
          case 0:
          // Navigate to Employee screen
            break;
          case 1:
          // Navigate to Add Employee screen
            break;
          case 2:
          // Navigate to Add Position screen
            break;
        }
      },
    );
  }
}
