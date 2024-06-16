import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/choose_based_token.dart';
import 'package:bloc_v2/add_register/add_register_employee.dart';
import 'package:bloc_v2/app_layout/controllers/app_layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AppLayoutScreen
class AppLayoutScreen extends StatelessWidget {
  /// AppLayoutScreen constructor
  const AppLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      AllEmployeeScreen(),
      const AddRegisterEmp(),
      HomeBody(), //will replace with profile screen to change the profile setting
    ];

    return BlocProvider(
      create: (context) => AppLayoutCubit(),
      child: BlocBuilder<AppLayoutCubit, int>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor:
                Color.fromARGB(255, 75, 72, 72), // Dark background color
            body: screens[state],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(
                  0xFF2D2D2D), // Dark background color for BottomNavigationBar
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(Icons.dashboard_sharp),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.dashboard_outlined,
                      color: Color(0xFFE8EAF6), // Light purple
                    ),
                  ),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(Icons.manage_accounts_outlined),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.manage_accounts,
                      color: Color(0xFFE8EAF6), // Light purple
                    ),
                  ),
                  label: 'Modify Data',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(Icons.person),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.person_2_rounded,
                      color: Color(0xFFE8EAF6), // Light purple
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
              currentIndex: state,
              onTap: (index) =>
                  context.read<AppLayoutCubit>().changeIndex(index),
              selectedItemColor:
                  const Color(0xFFE8EAF6), // Light purple for selected items
              unselectedItemColor:
                  const Color(0xFFB0BEC5), // Light grey for unselected items
              type: BottomNavigationBarType.fixed,
            ),
          );
        },
      ),
    );
  }
}
