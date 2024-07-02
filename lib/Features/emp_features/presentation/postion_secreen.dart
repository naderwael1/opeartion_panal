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
    futurePositions = fetchPositions();
  }

  IconData _getIconForPosition(String jobName) {
    switch (jobName.toLowerCase()) {
      // Custom logic to assign icons based on jobName
      case 'developer':
        return Icons.code;
      case 'manager':
        return Icons.business_center;
      case 'designer':
        return Icons.design_services;
      default:
        return Icons.work; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return ListView.separated(
                  itemCount: positions.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final position = positions[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          child: Icon(
                            _getIconForPosition(position.jobName),
                            color: Colors.teal.shade800,
                          ),
                        ),
                        title: Text(
                          position.jobName,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade600,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'ID: ${position.positionId}',
                          style: TextStyle(color: Colors.teal.shade900),
                        ),
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
