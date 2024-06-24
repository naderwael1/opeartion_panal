import 'package:bloc_v2/app_layout/controllers/app_layout_cubit.dart';
import 'package:bloc_v2/app_layout_BM/screens/get_all_employee_by_branch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppLayoutScreen
class AppLayoutScreenBMGET extends StatelessWidget {
  /// AppLayoutScreen constructor
  const AppLayoutScreenBMGET({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppLayoutCubit(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Branch Manager Operation', style: GoogleFonts.lato()),
            backgroundColor: Colors.teal,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.dashboard_sharp), text: 'Operation'),
                Tab(
                    icon: Icon(Icons.calendar_view_day_rounded),
                    text: 'Branch State'),
                Tab(icon: Icon(Icons.person), text: 'Profile'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              TableSreen(),
              TableSreen(),
              TableSreen(),
            ],
          ),
        ),
      ),
    );
  }
}
