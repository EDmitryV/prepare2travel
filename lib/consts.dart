import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/domain/entities/travel_preset.dart';

const String userBoxName = "user_box";
const String travelsBoxName = "travels_box";
const String serverAdr = "localhost:8090";
List<TravelPreset> baseTravelPresets = [
  TravelPreset(
      icon: Icons.directions_bike,
      itemsPerTravel: [
        Item(have: 0, name: "Bike", needed: 1),
        Item(have: 0, name: "Tent", needed: 1),
        Item(have: 0, name: "Sleeping Bag", needed: 1),
        Item(have: 0, name: "Cooking Gear", needed: 1),
        Item(have: 0, name: "Headlight", needed: 1),
        Item(have: 0, name: "Spare Tires", needed: 2),
        Item(have: 0, name: "Bike Lock", needed: 1),
        Item(have: 0, name: "Camera", needed: 1),
        Item(have: 0, name: "Charger", needed: 1),
        Item(have: 0, name: "Phone", needed: 1),
        Item(have: 0, name: "ID and Money", needed: 1),
        Item(have: 0, name: "Toiletries", needed: 1),
        Item(have: 0, name: "Clothes", needed: 5), // sets
        Item(have: 0, name: "Rain Gear", needed: 1)
      ],
      itemsPerDay: [
        Item(have: 0, name: "Water", needed: 2), // liters
        Item(have: 0, name: "Energy bars", needed: 3),
        Item(have: 0, name: "Meals", needed: 3),
        Item(have: 0, name: "Sunscreen", needed: 1), // application
        Item(have: 0, name: "Maps", needed: 1),
        Item(have: 0, name: "First Aid Kit", needed: 1),
        Item(have: 0, name: "Repair Kit", needed: 1),
        Item(have: 0, name: "Spare Tube", needed: 1),
        Item(have: 0, name: "Pump", needed: 1),
        Item(have: 0, name: "Helmet", needed: 1),
        Item(have: 0, name: "Gloves", needed: 1),
        Item(have: 0, name: "Cycling Shorts", needed: 1),
        Item(have: 0, name: "Cycling Jersey", needed: 1),
        Item(have: 0, name: "Cycling Shoes", needed: 1)
      ],
      name: 'Cycling tourism'),
  TravelPreset(
      icon: Icons.backpack,
      itemsPerTravel: [
        Item(have: 0, name: "Backpack", needed: 1),
        Item(have: 0, name: "Tent", needed: 1),
        Item(have: 0, name: "Sleeping Bag", needed: 1),
        Item(have: 0, name: "Cooking Gear", needed: 1),
        Item(have: 0, name: "Headlight", needed: 1),
        Item(have: 0, name: "Spare Batteries", needed: 2),
        Item(have: 0, name: "Compass", needed: 1),
        Item(have: 0, name: "Camera", needed: 1),
        Item(have: 0, name: "Charger", needed: 1),
        Item(have: 0, name: "Phone", needed: 1),
        Item(have: 0, name: "ID and Money", needed: 1),
        Item(have: 0, name: "Toiletries", needed: 1),
        Item(have: 0, name: "Clothes", needed: 5), // sets
        Item(have: 0, name: "Rain Gear", needed: 1)
      ],
      itemsPerDay: [
        Item(have: 0, name: "Water", needed: 2), // liters
        Item(have: 0, name: "Energy bars", needed: 3),
        Item(have: 0, name: "Meals", needed: 3),
        Item(have: 0, name: "Sunscreen", needed: 1), // application
        Item(have: 0, name: "Maps", needed: 1),
        Item(have: 0, name: "First Aid Kit", needed: 1),
        Item(have: 0, name: "Multi-tool", needed: 1),
        Item(have: 0, name: "Headlamp", needed: 1),
        Item(have: 0, name: "Hat", needed: 1),
        Item(have: 0, name: "Gloves", needed: 1),
        Item(have: 0, name: "Hiking Pants", needed: 1),
        Item(have: 0, name: "Hiking Shirt", needed: 1),
        Item(have: 0, name: "Hiking Boots", needed: 1),
        Item(have: 0, name: "Socks", needed: 1)
      ],
      name: 'Backpacking'),
  TravelPreset(
      icon: Icons.directions_car,
      itemsPerTravel: [
        Item(have: 0, name: "Car", needed: 1),
        Item(have: 0, name: "Tent", needed: 1),
        Item(have: 0, name: "Sleeping Bag", needed: 1),
        Item(have: 0, name: "Cooking Gear", needed: 1),
        Item(have: 0, name: "Headlight", needed: 1),
        Item(have: 0, name: "Spare Tires", needed: 2),
        Item(have: 0, name: "Car Repair Kit", needed: 1),
        Item(have: 0, name: "Camera", needed: 1),
        Item(have: 0, name: "Charger", needed: 1),
        Item(have: 0, name: "Phone", needed: 1),
        Item(have: 0, name: "ID and Money", needed: 1),
        Item(have: 0, name: "Toiletries", needed: 1),
        Item(have: 0, name: "Clothes", needed: 5), // sets
        Item(have: 0, name: "Rain Gear", needed: 1)
      ],
      itemsPerDay: [
        Item(have: 0, name: "Water", needed: 2), // liters
        Item(have: 0, name: "Snacks", needed: 3),
        Item(have: 0, name: "Meals", needed: 3),
        Item(have: 0, name: "Sunscreen", needed: 1), // application
        Item(have: 0, name: "Maps", needed: 1),
        Item(have: 0, name: "First Aid Kit", needed: 1),
        Item(have: 0, name: "Multi-tool", needed: 1),
        Item(have: 0, name: "Headlamp", needed: 1),
        Item(have: 0, name: "Hat", needed: 1),
        Item(have: 0, name: "Gloves", needed: 1),
        Item(have: 0, name: "Comfortable Pants", needed: 1),
        Item(have: 0, name: "Comfortable Shirt", needed: 1),
        Item(have: 0, name: "Comfortable Shoes", needed: 1),
        Item(have: 0, name: "Socks", needed: 1)
      ],
      name: 'Car tourism'),
  TravelPreset(
      icon: CommunityMaterialIcons.tent,
      itemsPerTravel: [
        Item(have: 0, name: "Tent", needed: 1),
        Item(have: 0, name: "Sleeping Bag", needed: 1),
        Item(have: 0, name: "Cooking Gear", needed: 1),
        Item(have: 0, name: "Headlight", needed: 1),
        Item(have: 0, name: "Spare Batteries", needed: 2),
        Item(have: 0, name: "Compass", needed: 1),
        Item(have: 0, name: "Camera", needed: 1),
        Item(have: 0, name: "Charger", needed: 1),
        Item(have: 0, name: "Phone", needed: 1),
        Item(have: 0, name: "ID and Money", needed: 1),
        Item(have: 0, name: "Toiletries", needed: 1),
        Item(have: 0, name: "Clothes", needed: 5), // sets
        Item(have: 0, name: "Rain Gear", needed: 1),
        Item(have: 0, name: "Backpack", needed: 1)
      ],
      itemsPerDay: [
        Item(have: 0, name: "Water", needed: 2), // liters
        Item(have: 0, name: "Energy bars", needed: 3),
        Item(have: 0, name: "Meals", needed: 3),
        Item(have: 0, name: "Sunscreen", needed: 1), // application
        Item(have: 0, name: "Maps", needed: 1),
        Item(have: 0, name: "First Aid Kit", needed: 1),
        Item(have: 0, name: "Multi-tool", needed: 1),
        Item(have: 0, name: "Headlamp", needed: 1),
        Item(have: 0, name: "Hat", needed: 1),
        Item(have: 0, name: "Gloves", needed: 1),
        Item(have: 0, name: "Hiking Pants", needed: 1),
        Item(have: 0, name: "Hiking Shirt", needed: 1),
        Item(have: 0, name: "Hiking Boots", needed: 1),
        Item(have: 0, name: "Socks", needed: 1)
      ],
      name: 'Camping tourism'),
];
