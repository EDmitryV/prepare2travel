import 'package:flutter/material.dart';
import 'package:prepare2travel/data/models/item.dart';

class TravelPreset {
  final String name;
  final List<Item> itemsPerTravel;
  final List<Item> itemsPerDay;
  final IconData icon;

  TravelPreset(
      {required this.name,
      required this.icon,
      required this.itemsPerTravel,
      required this.itemsPerDay});
}
