import 'package:bloc_v2/Features/branch_features/presentation/employeesAttendance_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/active_emp_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/add_emp.dart';
import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';
import 'package:bloc_v2/Features/emp_features/presentation/hrFlashy_tab_bar.dart';
import 'package:bloc_v2/add_register/add_register_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import '../../../Drawer/sidebarx.dart';
import '../../../core/utils/theme.dart';
import '../Data/get_all_emp_list.dart';
import 'custom_card.dart';
import 'custom_tool_bar.dart';

class AllEmployeeScreen extends StatefulWidget {
  @override
  _AllEmployeeScreenState createState() => _AllEmployeeScreenState();
}

class _AllEmployeeScreenState extends State<AllEmployeeScreen> {
  bool _showSearch = false;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();
  List<EmployeeModel> searchedForEmployeeList = [];
  List<EmployeeModel> allEmployeeList = [];
  int _selectedIndex = 0;

  void toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  void addSearchedFOrItemsToSearchedList(String searchedCharacter) {
    searchedForEmployeeList = allEmployeeList
        .where((employee) => employee.category
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
            /*  bottomNavigationBar: HrFlashyTabBar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onTabSelected,
            ),
            */
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
                  "List of State",
                  "Profile"
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
                            builder: (context) => const AddRegisterEmp()));
                  },
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmpAttendanceScreen()));
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
                          onPressed: () {
                            // todo
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
                        allEmployeeList = snapshot.data!;
                        List<EmployeeModel> employeesToShow =
                            _searchTextController.text.isEmpty
                                ? allEmployeeList
                                : searchedForEmployeeList;

                        return ListView.builder(
                          itemCount: employeesToShow.length,
                          itemBuilder: (context, index) {
                            return CustomCard(employee: employeesToShow[index]);
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
