import 'package:bloc_v2/Features/branch_features/presentation/get_details_branch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowDetailsBranch extends StatefulWidget {
  final int branchId;
  const ShowDetailsBranch({required this.branchId, Key? key}) : super(key: key);

  @override
  _ShowDetailsBranchState createState() => _ShowDetailsBranchState();
}

class _ShowDetailsBranchState extends State<ShowDetailsBranch> {
  late Future<Branch> futureBranchDetails;
  late Future<List<BranchComparison>> futureBranch15Days;
  late Future<List<BranchComparison>> futureBranch30Days;

  @override
  void initState() {
    super.initState();
    futureBranchDetails = fetchBranchDetails(widget.branchId);
    futureBranch15Days = fetchBranchComparison(15);
    futureBranch30Days = fetchBranchComparison(30);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Branch Details',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildFutureBuilder('Branch Details', futureBranchDetails, screenSize),
            buildFutureBuilderComparison('Last 15 Days', futureBranch15Days, screenSize),
            buildFutureBuilderComparison('Last 30 Days', futureBranch30Days, screenSize),
          ],
        ),
      ),
    );
  }

  Widget buildFutureBuilder(String title, Future<Branch> futureData, Size screenSize) {
    return FutureBuilder<Branch>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No Data Found'));
        } else {
          final branch = snapshot.data!;
          return buildBranchDetailsCard(title, branch, screenSize);
        }
      },
    );
  }

  Widget buildFutureBuilderComparison(String title, Future<List<BranchComparison>> futureData, Size screenSize) {
    return FutureBuilder<List<BranchComparison>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Data Found'));
        } else {
          final branchData = snapshot.data!.firstWhere((branch) => branch.branchId == widget.branchId, orElse: () => BranchComparison(branchId: 0, branchName: '', totalSales: 0, totalOrders: 0));
          if (branchData.branchId == 0) {
            return Center(child: Text('Branch not found'));
          }
          return buildDataCard(title, branchData, screenSize);
        }
      },
    );
  }

  Widget buildBranchDetailsCard(String title, Branch branch, Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.05),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: screenSize.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              buildInfoRow(
                icon: Icons.location_city,
                title: 'Branch Name',
                subtitle: capitalizeFirstTwoWords(branch.name),
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.location_on,
                title: 'Address',
                subtitle: capitalizeFirstTwoWords(branch.address),
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.phone,
                title: 'Phone',
                subtitle: capitalizeFirstTwoWords(branch.phone),
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.calendar_today,
                title: 'Created Date',
                subtitle: capitalizeFirstTwoWords(extractDate(branch.createdDate)),
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.map,
                title: 'Location',
                subtitle: '(${branch.latitude}, ${branch.longitude})',
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.security,
                title: 'Coverage',
                subtitle: '${branch.coverage} km',
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.person,
                title: 'Manager',
                subtitle: '${capitalizeFirstTwoWords(branch.managerName)} (ID: ${branch.managerId})',
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.table_chart,
                title: 'Tables',
                subtitle: capitalizeFirstTwoWords(branch.tables),
                screenSize: screenSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataCard(String title, BranchComparison branch, Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.05),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: screenSize.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              buildInfoRow(
                icon: Icons.location_city,
                title: 'Branch Name',
                subtitle: capitalizeFirstTwoWords(branch.branchName),
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.attach_money,
                title: 'Total Sales',
                subtitle: capitalizeFirstTwoWords(branch.totalSales.toStringAsFixed(2)),
                screenSize: screenSize,
              ),
              buildInfoRow(
                icon: Icons.shopping_cart,
                title: 'Total Orders',
                subtitle: capitalizeFirstTwoWords(branch.totalOrders.toString()),
                screenSize: screenSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Size screenSize,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: screenSize.width * 0.08),
          SizedBox(width: screenSize.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      color: Colors.grey[700],
                    ),
                  ),
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String capitalizeFirstTwoWords(String input) {
    if (input.isEmpty) return input;
    List<String> words = input.split(' ');
    for (int i = 0; i < words.length && i < 2; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
    return words.join(' ');
  }
}
