import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  @HiveField(3)
  String? id;

  //other
  Item(
      {required this.name,
      required this.needed,
      required this.have,
      this.id});
  factory Item.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Item(
        name: data['name'],
        needed: data['needed'],
        have: data['have'],
        id: document.id);
  }
  Item copyWith({String? name, int? needed, int? have, String? id}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      needed: needed ?? this.needed,
      have: have ?? this.have,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'needed': needed,
      'have': have,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as String,
      name: map['name'] as String,
      needed: map['needed'] as int,
      have: map['have'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Item(id: $id, name: $name, needed: $needed, have: $have)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.needed == needed &&
        other.have == have &&
        other.id == id;
  }

  @override
  int get hashCode =>
      name.hashCode ^ needed.hashCode ^ have.hashCode ^ id.hashCode;
}
