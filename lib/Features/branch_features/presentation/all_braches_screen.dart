import 'package:bloc_v2/Features/branch_features/Data/get_all_branchs.dart';
import 'package:bloc_v2/Features/branch_features/presentation/custom_branch_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';
import 'package:google_fonts/google_fonts.dart';

class AllBranchScreen extends StatelessWidget {
  const AllBranchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return connected
            ? buildConnectedScreen(context)
            : noInternetWidget(context);
      },
      child: const Text('No internet connection'),
    );
  }

  Widget noInternetWidget(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('No Connection', style: GoogleFonts.openSans())),
      body: Center(
        child: Text(
          'No Internet Connection.\nPlease check your network settings and try again.',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  Widget buildConnectedScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Branches', style: GoogleFonts.openSans()),
        centerTitle: true,
      ),
      body: FutureBuilder<List<BranchModel>>(
        future: GetAllBranches()
            .getAllBranches(), // Your actual data fetching function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CustomCard(branch: snapshot.data![index]);
              },
            );
          } else {
            return Center(
                child:
                    Text('No branches found', style: GoogleFonts.openSans()));
          }
        },
      ),
    );
  }
}
