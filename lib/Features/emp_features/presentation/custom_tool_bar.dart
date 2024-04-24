import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomToolBar extends StatefulWidget {
  CustomToolBar({Key? key}) : super(key: key);

  @override
  _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBar> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const AllEmployeeScreen(),
      const AddPositionScreen(),
      const AddPositionScreen(),
      const AddPositionScreen(),
      const AddPositionScreen(),
      const AddPositionScreen(),
      const AddPositionScreen(),
      const AddPositionScreen(),
    ];

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: screens.length, // Adjusted to directly use screens.length
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screens[index]),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.all(5),
              width: 100,
              height: 55,
              decoration: BoxDecoration(
                color: current == index ? Colors.white70 : Colors.white54,
                borderRadius: current == index
                    ? BorderRadius.circular(12)
                    : BorderRadius.circular(7),
                border: current == index
                    ? Border.all(color: Colors.deepPurpleAccent, width: 2.5)
                    : null,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      [
                        Icons.home,
                        Icons.explore,
                        Icons.search,
                        Icons.feed,
                        Icons.post_add,
                        Icons.local_activity,
                        Icons.settings,
                        Icons.person
                      ][index],
                      size: current == index ? 23 : 20,
                      color: current == index
                          ? Colors.black
                          : Colors.grey.shade400,
                    ),
                    Text(
                      [
                        "Home",
                        "Explore",
                        "Search",
                        "Feed",
                        "Posts",
                        "Activity",
                        "Setting",
                        "Profile"
                      ][index],
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w500,
                        color: current == index
                            ? Colors.black
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
