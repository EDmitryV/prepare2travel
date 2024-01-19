import 'dart:convert';

import 'package:hive_flutter/adapters.dart';

part 'item.g.dart';

@HiveType(typeId: 3)
class Item extends HiveObject {
  //fields
  @HiveField(0)
  String name;
  @HiveField(1)
  int needed;
  @HiveField(2)
  int have;

  //other
  Item({
    required this.name,
    required this.needed,
    required this.have,
  });

  Item copyWith({
    String? name,
    int? needed,
    int? have,
  }) {
    return Item(
      name: name ?? this.name,
      needed: needed ?? this.needed,
      have: have ?? this.have,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'needed': needed,
      'have': have,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] as String,
      needed: map['needed'] as int,
      have: map['have'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Item(name: $name, needed: $needed, have: $have)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.name == name && other.needed == needed && other.have == have;
  }

  @override
  int get hashCode => name.hashCode ^ needed.hashCode ^ have.hashCode;
}
