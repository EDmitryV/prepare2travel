import 'package:prepare2travel/data/models/travel.dart';

abstract class AbstractTravelRepository {
  Future<Travel> createTravel(Travel travel);
  Future<List<Travel>> getAllTravels();
  Future<Travel?> getTravel(dynamic key);
  Future<Travel> updateTravel(Travel travel);
  Future<bool> deleteTravel(Travel travel);
}
