import 'package:flutter/material.dart';
import 'package:bloc_v2/Features/branch_features/Data/get_all_OM_function.dart';
import 'package:bloc_v2/Features/branch_features/models/OM_function_model.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipesList extends StatefulWidget {
  final int branchID;

  RecipesList(this.branchID, {required int iD});

  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  late Future<List<SectionModel>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = GetSection().getSection(branchID: widget.branchID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Section List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(209, 239, 234, 1),
              Colors.grey
            ], // Adjust the color range as needed
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Details',
                style: GoogleFonts.nunito(
                  // A cleaner, more professional font
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(
                      255, 45, 17, 95), // Changed to a more pleasant color
                ),
              ),
            ),
            Container(
              height: 2,
              color:
                  Colors.black87, // Solid line with color that fits the theme
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity, // Line width matches the screen width
            ),
            Container(
              color: Colors.teal[100],
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)),
                  Expanded(
                      child: Text('Manager',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)),
                  Expanded(
                      child: Text('Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<SectionModel>>(
                future: recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        SectionModel section = snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.zero, // Remove space between cards
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero), // Remove rounded corners
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(section.sectionName,
                                      textAlign: TextAlign.center),
                                ),
                                Expanded(
                                  child: Text(section.sectionManager ?? "",
                                      textAlign: TextAlign.center),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: const Icon(Icons.description),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Description"),
                                            content: Text(
                                                section.sectionDecription ??
                                                    "No description available"),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
