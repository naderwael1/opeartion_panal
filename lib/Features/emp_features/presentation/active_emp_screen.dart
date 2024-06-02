import '../Data/get_active_emp.dart';
import '../models/active_emp_model.dart';
import '../../../Drawer/customDrawer.dart';
import 'package:flutter/material.dart';
import 'custom_active_card.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../../custom_nav_bar.dart';

class ActiveEmployeeScreen extends StatefulWidget {
  const ActiveEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<ActiveEmployeeScreen> createState() => _ActiveEmployeeScreenState();
}

class _ActiveEmployeeScreenState extends State<ActiveEmployeeScreen> {
  late List<ActiveEmployeesModel> allEmployees;
  late List<ActiveEmployeesModel> searchedForEmployees;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: Theme.of(context).hintColor,
      decoration: const InputDecoration(
        hintText: 'Find an employee...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
      ),
      style: const TextStyle(color: Colors.black87, fontSize: 18),
      onChanged: (searchedEmployee) {
        addSearchedForItemsToSearchedList(searchedEmployee);
      },
    );
  }

  void addSearchedForItemsToSearchedList(String searchedEmployee) {
    searchedForEmployees = allEmployees
        .where((employee) => employee.employeeName!
            .toLowerCase()
            .startsWith(searchedEmployee.toLowerCase()))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear, color: Colors.grey),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
      ];
    }
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

  Widget NoInternetWidget() {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            const Text(
              'Can\'t connect to the internet. Please check your connection',
              style: TextStyle(fontSize: 22),
            ),
            Image.asset('assets/images/undraw_bug_fixing_oc7a.png'),
          ],
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
            drawer: const CustomDrawer(),
            bottomNavigationBar: const MyBottomNavigationBar(),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 29, 51, 71), // Updated color
              leading: _isSearching
                  ? const BackButton(
                      color: Colors.white,
                    )
                  : Container(),
              title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
              actions: _buildAppBarActions(),
            ),
            body: FutureBuilder<List<ActiveEmployeesModel>>(
              future: GetActiveEmployee().fetchActiveEmployees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  allEmployees = snapshot.data!;
                  return buildLoadedListWidgets(context);
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          );
        } else {
          return NoInternetWidget();
        }
      },
      child: const Text('No internet connection'),
    );
  }

  Widget _buildAppBarTitle() {
    return const Text(
      'All Employees',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget buildLoadedListWidgets(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            buildEmployeesList(),
          ],
        ),
      ),
    );
  }

  Widget buildEmployeesList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchTextController.text.isEmpty
          ? allEmployees.length
          : searchedForEmployees.length,
      itemBuilder: (ctx, index) {
        return CustomActiveCard(
          activeEmployee: _searchTextController.text.isEmpty
              ? allEmployees[index]
              : searchedForEmployees[index],
        );
      },
    );
  }
}
