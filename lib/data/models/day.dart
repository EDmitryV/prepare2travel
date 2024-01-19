import 'dart:convert';

import 'package:hive_flutter/adapters.dart';

part 'day.g.dart';

@HiveType(typeId: 2)
class Day extends HiveObject {
  //fields
  @HiveField(0)
  DateTime? date;
  @HiveField(1)
  double? minTemperature;
  @HiveField(2)
  double? maxTemperature;
  @HiveField(3)
  double? humidity;
  @HiveField(4)
  String? precipitation;
  @HiveField(5)
  String? interesting;

  //other
  Day({
     this.date,
     this.minTemperature,
     this.maxTemperature,
     this.humidity,
     this.precipitation,
     this.interesting,
  });

  Day copyWith({
    DateTime? date,
    double? humidity,
    double? minTemperature,
    double? maxTemperature,
    String? precipitation,
    String? interesting,
  }) {
    return Day(
      date: date ?? this.date,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      humidity: humidity ?? this.humidity,
      precipitation: precipitation ?? this.precipitation,
      interesting: interesting ?? this.interesting,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date!.millisecondsSinceEpoch,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'humidity': humidity,
      'precipitation': precipitation,
      'interesting': interesting,
    };
  }

  factory Day.fromMap(Map<String, dynamic> map) {
    return Day(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      minTemperature: map['minTemperature'] as double,
      maxTemperature: map['maxTemperature'] as double,
      humidity: map['humidity'] as double,
      precipitation: map['precipitation'] as String?,
      interesting: map['interesting'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Day.fromJson(String source) =>
      Day.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Date(date: $date, minTemperature: $minTemperature, maxTemperature: $maxTemperature, humidity: $humidity, precipitation: $precipitation, interesting: $interesting)';
  }

  @override
  bool operator ==(covariant Day other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.minTemperature == minTemperature &&
        other.maxTemperature == maxTemperature &&
        other.humidity == humidity &&
        other.precipitation == precipitation &&
        other.interesting == interesting;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        minTemperature.hashCode ^
        maxTemperature.hashCode ^
        humidity.hashCode ^
        precipitation.hashCode ^
        interesting.hashCode;
  }
}
