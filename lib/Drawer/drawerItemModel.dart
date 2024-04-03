import 'package:flutter/material.dart';

class DrawerItemModel {
  final String title;
  final IconData icon;
  final Widget destination; // Destination screen type

  const DrawerItemModel({
    required this.title,
    required this.icon,
    required this.destination,
  });
}
