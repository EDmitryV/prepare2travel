import 'package:hive_flutter/hive_flutter.dart';
part 'user_sex.g.dart';
@HiveType(typeId: 5)
enum UserSex {
  @HiveField(0)
  male(0),
  @HiveField(1)
  female(1),
  @HiveField(2)
  other(2);

  const UserSex(this.value);
  final int value;
  static UserSex getByValue(int i) {
    return UserSex.values.firstWhere((x) => x.value == i);
  }

  static UserSex getByName(String name) {
    return UserSex.values.firstWhere((x) => x.displayName == name);
  }

  String get displayName {
    switch (this) {
      case UserSex.male:
        return 'Male';//TODO 
      case UserSex.female:
        return 'Female';//TODO
      case UserSex.other:
        return 'Other';//TODO
      default:
        return '';
    }
  }
}
