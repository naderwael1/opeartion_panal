import 'package:bloc_v2/Features/emp_features/Data/get_all_positions.dart';
import 'package:bloc_v2/Features/emp_features/models/positon_models.dart';
import 'package:bloc_v2/Features/emp_features/presentation/custom_clip_path';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PositionListScreen extends StatefulWidget {
  @override
  _PositionListScreenState createState() => _PositionListScreenState();
}

class _PositionListScreenState extends State<PositionListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<PositionModel>> futurePositions;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Ensure that the future is initialized after setting up the animation
    futurePositions = fetchPositions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Positions',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              color: Colors.teal.withOpacity(0.2),
              height: 200,
            ),
          ),
          FutureBuilder<List<PositionModel>>(
            future: futurePositions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No positions found'));
              } else {
                final positions = snapshot.data!;
                return FadeTransition(
                  opacity: _animation,
                  child: ListView.builder(
                    itemCount: positions.length,
                    itemBuilder: (context, index) {
                      final position = positions[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            position.jobName,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          subtitle: Text('ID: ${position.positionId}'),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
