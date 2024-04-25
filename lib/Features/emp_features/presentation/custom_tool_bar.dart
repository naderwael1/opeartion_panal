import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomToolBar extends StatefulWidget {
  final VoidCallback onExploreTap;

  CustomToolBar({Key? key, required this.onExploreTap}) : super(key: key);

  @override
  _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBar> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "Home",
      "Explore",
      "Search",
      "Feed",
      "Posts",
      "Activity",
      "Setting",
      "Profile",
    ];

    final List<IconData> icons = [
      Icons.home,
      Icons.explore,
      Icons.search,
      Icons.feed,
      Icons.post_add,
      Icons.local_activity,
      Icons.settings,
      Icons.person,
    ];

    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
              });
              if (index == 1) {
                // Assuming "Explore" is at index 1
                widget.onExploreTap();
              }
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
                      icons[index],
                      size: current == index ? 23 : 20,
                      color: current == index
                          ? Colors.black
                          : Colors.grey.shade400,
                    ),
                    Text(
                      titles[index],
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
