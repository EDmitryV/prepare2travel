// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:prepare2travel/data/models/day.dart';
import 'package:prepare2travel/data/models/item.dart';

part 'travel.g.dart';

@HiveType(typeId: 4)
class Travel extends HiveObject {
  //fields
  @HiveField(0)
  final String country;
  @HiveField(1)
  final String region;
  @HiveField(2)
  final String city;
  @HiveField(3)
  final List<Day> days;
  @HiveField(4)
  final List<Item> items;
  @HiveField(6)
  final DateTime creationDate;
  @HiveField(7)
  String? id;

  //other
  Travel({
    required this.country,
    required this.region,
    required this.city,
    required this.days,
    required this.items,
    required this.creationDate,
    this.id,
  });
  //Need to load data from collections
  factory Travel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Travel(
      id: document.id,
      region: data["region"],
      country: data['country'],
      city: data['city'],
      creationDate: data['creationDate'],
      days: [],
      items: [],
    );
  }
  Travel copyWith({
    String? country,
    String? region,
    String? city,
    List<Day>? days,
    List<Item>? items,
    bool? business,
    DateTime? creationDate,
    String? id,
  }) {
    return Travel(
      country: country ?? this.country,
      region: region ?? this.region,
      city: city ?? this.city,
      days: days ?? this.days,
      items: items ?? this.items,
      creationDate: creationDate ?? this.creationDate,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'region': region,
      'city': city,
      // 'days': days.map((x) => x.toMap()).toList(),
      // 'items': items.map((x) => x.toMap()).toList(),
      'creationDate': creationDate.millisecondsSinceEpoch,
      'id': id
    };
  }

  factory Travel.fromMap(Map<String, dynamic> map) {
    return Travel(
      id: map['id'] as String,
      country: map['country'] as String,
      region: map['region'] as String,
      city: map['city'] as String,
      days: [],
      items: [],
      // days: List<Day>.from(
      //   (map['days'] as List<dynamic>).map<Day>(
      //     (x) => Day.fromMap(x as Map<String, dynamic>),
      //   ),
      // ),
      // items: List<Item>.from(
      //   (map['items'] as List<dynamic>).map<Item>(
      //     (x) => Item.fromMap(x as Map<String, dynamic>),
      //   ),
      // ),
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Travel.fromJson(String source) =>
      Travel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Travel(id: $id, country: $country, region: $region, city: $city, days: $days, items: $items,  creationDate: $creationDate)';
  }

  @override
  bool operator ==(covariant Travel other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.region == region &&
        other.city == city &&
        listEquals(other.days, days) &&
        listEquals(other.items, items) &&
        other.creationDate == creationDate &&
        other.id == id;
  }

  @override
  int get hashCode {
    return country.hashCode ^
        region.hashCode ^
        city.hashCode ^
        days.hashCode ^
        items.hashCode ^
        creationDate.hashCode ^
        id.hashCode;
  }
}
