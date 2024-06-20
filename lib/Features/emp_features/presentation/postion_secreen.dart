import 'package:bloc_v2/Features/emp_features/Data/get_all_positions.dart';
import 'package:bloc_v2/Features/emp_features/models/positon_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PositionListScreen extends StatefulWidget {
  @override
  _PositionListScreenState createState() => _PositionListScreenState();
}

class _PositionListScreenState extends State<PositionListScreen> {
  late Future<List<PositionModel>> futurePositions;

  @override
  void initState() {
    super.initState();
    // Ensure that the future is initialized
    futurePositions = fetchPositions();
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
                return ListView.builder(
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
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
