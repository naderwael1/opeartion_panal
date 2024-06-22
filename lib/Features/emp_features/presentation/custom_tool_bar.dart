import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomToolBar extends StatefulWidget {
  final List<String> titles;
  final List<IconData> icons;
  final List<VoidCallback> callbacks;

  CustomToolBar({
    Key? key,
    required this.titles,
    required this.icons,
    required this.callbacks,
  })  : assert(
            titles.length == icons.length && icons.length == callbacks.length,
            "Titles, icons, and callbacks must have the same length"),
        super(key: key);

  @override
  _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBar> {
  int current = 0;

  @override
  void initState() {
    super.initState();
    // Detailed debug statements
    print("Titles length: ${widget.titles.length}");
    print("Icons length: ${widget.icons.length}");
    print("Callbacks length: ${widget.callbacks.length}");
    print("Titles: ${widget.titles}");
    print("Icons: ${widget.icons}");
    print("Callbacks: ${widget.callbacks}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade100, Colors.blueGrey.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.titles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
              });
              widget.callbacks[index]();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.all(5),
              width: _calculateWidth(index),
              height: 55,
              decoration: BoxDecoration(
                color: current == index ? Colors.white70 : Colors.white54,
                borderRadius: current == index
                    ? BorderRadius.circular(12)
                    : BorderRadius.circular(7),
                border: current == index
                    ? Border.all(color: Colors.blueGrey.shade700, width: 2.5)
                    : null,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icons[index],
                      size: current == index ? 23 : 20,
                      color: current == index
                          ? Colors.blueGrey.shade900
                          : Colors.grey.shade400,
                    ),
                    Text(
                      widget.titles[index],
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        color: current == index
                            ? Colors.blueGrey.shade900
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

  double _calculateWidth(int index) {
    final text = widget.titles[index];
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: 16.0), // Adjust font size if needed
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width + 20; // Adjust padding as needed
  }
}
