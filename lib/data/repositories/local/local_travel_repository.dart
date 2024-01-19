import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/domain/repositories/abstract_travel_repository.dart';

class LocalTravelRepository extends AbstractTravelRepository {
  final Box<Travel> _travelBox;

  LocalTravelRepository({required Box<Travel> travelBox})
      : _travelBox = travelBox;

  @override
  Future<Travel> createTravel(Travel travel) async {
    await _travelBox.add(travel);
    return travel;
  }

  @override
  Future<bool> deleteTravel(Travel travel) async {
    await travel.delete();
    return true;
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    return _travelBox.values.toList();
  }

  @override
  Future<Travel?> getTravel(dynamic key) async {
    return _travelBox.get(key);
  }

  @override
  Future<Travel> updateTravel(Travel travel) async {
    await travel.save();
    return travel;
  }
}
