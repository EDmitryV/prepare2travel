// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_sex.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSexAdapter extends TypeAdapter<UserSex> {
  @override
  final int typeId = 5;

  @override
  UserSex read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserSex.male;
      case 1:
        return UserSex.female;
      case 2:
        return UserSex.other;
      default:
        return UserSex.male;
    }
  }

  @override
  void write(BinaryWriter writer, UserSex obj) {
    switch (obj) {
      case UserSex.male:
        writer.writeByte(0);
        break;
      case UserSex.female:
        writer.writeByte(1);
        break;
      case UserSex.other:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSexAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
