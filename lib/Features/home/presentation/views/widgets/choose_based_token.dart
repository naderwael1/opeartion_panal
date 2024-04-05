import 'package:flutter/material.dart';
import '../../../../../Drawer/customDrawer.dart';
import '../../../../../constants.dart';
import 'custom_category_card.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),

      appBar: AppBar(
        title: const Text('Mat3m 7baib Elsaida'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Two cards per row
        children: const [
          CustomCard(
            text: 'HR Dept',
            photoUrl: hrImage,
          ),
          CustomCard(
            text: 'Operation Manager',
            photoUrl: operationImage,
          ),
          CustomCard(
            text: 'Branch Manager',
            photoUrl: mangerImage,
          ),
          CustomCard(
            text: 'Storage',
            photoUrl: storgeImage,
          ),
        ],
      ),
    );
  }
}


