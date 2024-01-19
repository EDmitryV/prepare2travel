// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TravelAdapter extends TypeAdapter<Travel> {
  @override
  final int typeId = 4;

  @override
  Travel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Travel(
      country: fields[0] as String,
      region: fields[1] as String,
      city: fields[2] as String,
      days: (fields[3] as List).cast<Day>(),
      items: (fields[4] as List).cast<Item>(),
      creationDate: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Travel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.country)
      ..writeByte(1)
      ..write(obj.region)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.days)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.creationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
