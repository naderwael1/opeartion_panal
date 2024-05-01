import 'package:bloc_v2/Features/branch_features/presentation/employeesAttendance_screen.dart';
import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import 'package:bloc_v2/Features/emp_features/presentation/active_emp_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Drawer/customDrawer.dart';
import '../../../Drawer/sidebarx.dart';
import '../../../core/utils/theme.dart';
import '../../../custom_nav_bar.dart';
import '../Data/get_all_emp_list.dart';
import 'add_emp.dart';
import 'custom_card.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'custom_tool_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class AllEmployeeScreen extends StatefulWidget {
  @override
  _AllEmployeeScreenState createState() => _AllEmployeeScreenState();
}

class _AllEmployeeScreenState extends State<AllEmployeeScreen> {
  bool _showSearch = false;

  void toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  void goScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddPositionScreen()));
  }

  void goAttendanceScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EmpAttendanceScreen()));
  }

  void goStateScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ActiveEmployeeScreen()));
  }

  Widget NoInternetWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/undraw_bug_fixing_oc7a.png',
                  height: 200), // Ensure you have an appealing image
              const SizedBox(height: 40),
              const Text(
                'Oops! No Internet Connection.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Please check your network settings and try again.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  //todo
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context)
                      .primaryColor, // This sets the text color on the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connected) {
          return Scaffold(
            drawer: const sideBarHR(),
            appBar: AppBar(
              title: const Text('All Employee'),
              actions: const [
                ThemeToggleWidget(),
              ],
            ),
            body: Column(
              children: [
                CustomToolBar(titles: const [
                  "Explore",
                  "Add",
                  "Attendance",
                  "List of Sate",
                  "profile "
                ], icons: const [
                  Icons.explore,
                  Icons.add,
                  Icons.feed,
                  Icons.quiz_sharp,
                  Icons.person,
                ], callbacks: [
                  toggleSearch,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddEmp()));
                  },
                  goAttendanceScreen,
                  goStateScreen,
                  goScreen
                ]),
                Visibility(
                  visible: _showSearch,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Implement filter logic
                          },
                          icon: const Icon(Icons.filter_list),
                          label: const Text('Filter'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<EmployeeModel>>(
                    future: GetAllEmployee().getAllProduct(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        List<EmployeeModel> employees = snapshot.data!;
                        return ListView.builder(
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            return CustomCard(employee: employees[index]);
                          },
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return NoInternetWidget();
        }
      },
      child: const Text('No internet connection'),
    );
  }
}
