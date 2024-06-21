import 'package:bloc_v2/Features/emp_features/Data/get_active_emp.dart';
import 'package:bloc_v2/Features/emp_features/models/active_emp_model.dart';
import 'package:bloc_v2/Features/emp_features/presentation/active_emp_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/get_managers_list.dart';
import 'package:bloc_v2/Features/emp_features/presentation/hrFlashy_tab_bar.dart';
import 'package:bloc_v2/Features/emp_features/presentation/postion_secreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'dart:async'; // Import dart:async for Timer

import '../../../core/utils/theme.dart';
import 'custom_card.dart';
import 'custom_tool_bar.dart';

class AllEmployeeScreen extends StatefulWidget {
  @override
  _AllEmployeeScreenState createState() => _AllEmployeeScreenState();
}

class _AllEmployeeScreenState extends State<AllEmployeeScreen> {
  bool _showSearch = false;
  bool _isSearching = false;
  int _selectedIndex = 0;
  final _searchTextController = TextEditingController();
  List<ActiveEmployeesModel> searchedForEmployeeList = [];
  List<ActiveEmployeesModel> allEmployeeList = [];
  bool _isShowingActive = true; // New state variable
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchTextController.dispose();
    super.dispose();
  }

  void _startPolling() {
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    _fetchEmployees();
  });

  Future.delayed(Duration(seconds: 1), () {
    _timer?.cancel();
  });
}

  void _fetchEmployees() {
    setState(() {});
  }

  void toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  void addSearchedFOrItemsToSearchedList(String searchedCharacter) {
    searchedForEmployeeList = allEmployeeList
        .where((activeEmployee) => activeEmployee.employeeName
            .toLowerCase()
            .startsWith(searchedCharacter.toLowerCase()))
        .toList();
    setState(() {});
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HrFlashyTabBar.tabItems[index].screen),
    );
  }

  void _toggleEmployeeStatus() {
    setState(() {
      _isShowingActive = !_isShowingActive;
    });
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
                  height: 200),
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
                  backgroundColor: Theme.of(context).primaryColor,
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
                  "All Positions",
                  "All Managers",
                  "List of State",
                  "Profile"
                ], icons: const [
                  Icons.explore,
                  Icons.workspaces,
                  Icons.feed,
                  Icons.quiz_sharp,
                  Icons.person,
                ], callbacks: [
                  toggleSearch,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PositionListScreen()));
                  },
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagersListScreen()));
                  },
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ActiveEmployeeScreen()));
                  },
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPositionScreen()));
                  }
                ]),
                Visibility(
                  visible: _showSearch,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchTextController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (searchedCharacter) {
                              addSearchedFOrItemsToSearchedList(
                                  searchedCharacter);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _toggleEmployeeStatus,
                          icon: const Icon(Icons.filter_list),
                          label: Text(_isShowingActive ? 'Show Inactive' : 'Show Active'),
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
                  child: FutureBuilder<List<ActiveEmployeesModel>>(
                    future: _isShowingActive
                        ? GetActiveEmployee().fetchActiveEmployees()
                        : GeIntActiveEmployee().geIntActiveEmployee(), // Assuming a similar function for inactive employees
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        allEmployeeList = snapshot.data!;
                        List<ActiveEmployeesModel> employeesToShow =
                            _searchTextController.text.isEmpty
                                ? allEmployeeList
                                : searchedForEmployeeList;

                        return ListView.builder(
                          itemCount: employeesToShow.length,
                          itemBuilder: (context, index) {
                            return CustomCard(
                              activeEmployee: employeesToShow[index],
                              startPolling: _startPolling, // Pass the startPolling function here
                            );
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
