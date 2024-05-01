import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';

class CustomCard extends StatelessWidget {
  final BranchModel branch;

  const CustomCard({
    required this.branch,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            branch.branchID.toString(),
            style: GoogleFonts.openSans(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          branch.branchName,
          style: GoogleFonts.openSans(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            // Navigate or do action here
          },
        ),
      ),
    );
  }
}
