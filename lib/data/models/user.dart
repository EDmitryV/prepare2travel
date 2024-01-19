import 'dart:convert';
import 'package:hive_flutter/adapters.dart';
import 'package:prepare2travel/data/models/user_sex.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  //fields
  @HiveField(0)
  UserSex sex;
  @HiveField(1)
  String username;
  @HiveField(2)
  int id;
  //other
  User({required this.sex, required this.username, required this.id});

  User copyWith({UserSex? sex, String? username, int? id}) {
    return User(
        sex: sex ?? this.sex,
        username: username ?? this.username,
        id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'sex': sex.value, 'username': username, 'id': id};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        sex: UserSex.getByValue(map['sex'] as int),
        username: map['username'],
        id: map['id']);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'User(sex: ${sex.displayName}, username: $username, id: $id)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.sex == sex && other.username == username && other.id == id;
  }

  @override
  int get hashCode => sex.hashCode ^ username.hashCode ^ id.hashCode;

  User copyParamsFrom({required User user}) {
    sex = user.sex;
    username = user.username;
    id = user.id;
    return this;
  }
}
