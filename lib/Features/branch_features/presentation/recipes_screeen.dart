import 'package:bloc_v2/Features/branch_features/Data/get_all_OM_function.dart';
import 'package:bloc_v2/Features/branch_features/models/OM_function_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bloc_v2/Features/branch_features/Data/get_all_OM_function.dart';
import 'package:bloc_v2/Features/branch_features/models/OM_function_model.dart';
import 'package:flutter/material.dart';

class RecipesList extends StatefulWidget {
  final int branchID;

  RecipesList(this.branchID);

  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  late Future<List<RecipesModel>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = GetRecipes().getRecipes(branchID: widget.branchID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes List'),
      ),
      body: FutureBuilder<List<RecipesModel>>(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Text(
                    "Details",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromRGBO(
                          33, 150, 243, 1), // Adjust color as needed
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey, // Adjust color as needed
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      RecipesModel recipe = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          leading: Text(recipe.iD.toString()),
                          title: Text(recipe.sectionName),
                          subtitle: Text(recipe.sectionManager ?? ""),
                          trailing: IconButton(
                            icon: const Icon(Icons.description),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(recipe.sectionName),
                                    content: Text(recipe.sectionDecription),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
