import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'Features/emp_features/presentation/all_emp_screen.dart';
import 'Features/emp_features/presentation/active_emp_screen.dart';
import 'spincircle.dart';
import 'Features/emp_features/presentation/add_position_screen.dart';

//
class SpincircleAll extends StatefulWidget {
  @override
  _SpincircleState createState() => _SpincircleState();
}

class _SpincircleState extends State<SpincircleAll> {
  @override
  Widget build(BuildContext context) {
    return HrNavBar();
  }

  Scaffold HrNavBar() {
    return Scaffold(
      body: SpinCircleBottomBarHolder(
        bottomNavigationBar: SCBottomBarDetails(
          items: [
            SCBottomBarItem(
                icon: Iconsax.home,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SpincircleAll()));
                }),
            SCBottomBarItem(
                icon: Icons.person_2_outlined,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Spincircle()));
                }),
            SCBottomBarItem(
                icon: Icons.person_2_sharp,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ActiveEmployeeScreen()));
                }),
            SCBottomBarItem(icon: Iconsax.logout, onPressed: () {}),
            SCBottomBarItem(icon: Icons.settings, onPressed: () {}),
          ],
          circleItems: [
            SCItem(icon: Icon(Icons.person_add_alt), onPressed: () {}),
            SCItem(
                icon: Icon(Icons.workspace_premium_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPositionScreen()));
                }),
          ],
          circleColors: [
            Colors.black,
            Colors.white,
            Colors.orange,
          ],
          iconTheme: IconThemeData(color: Colors.black45),
          activeIconTheme:
              IconThemeData(color: Color.fromARGB(115, 13, 13, 63)),
          titleStyle:
              TextStyle(color: Color.fromARGB(115, 13, 13, 63), fontSize: 12),
          activeTitleStyle: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        child: AllEmployeeScreen(),
      ),
    );
  }
}
