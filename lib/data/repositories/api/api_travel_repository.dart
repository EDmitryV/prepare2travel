import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/repositories/local/local_travel_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_user_repository.dart';
import 'package:prepare2travel/domain/repositories/abstract_travel_repository.dart';

class ApiTravelRepository extends AbstractTravelRepository {
  final Dio _dio;
  final LocalTravelRepository _localTravelRepository;
  final LocalUserRepository _localUserRepository;

  ApiTravelRepository(
      {required Box<Travel> travelBox,
      required Dio dio,
      required LocalTravelRepository localTravelRepository,
      required LocalUserRepository localUserRepository})
      : _dio = dio,
        _localTravelRepository = localTravelRepository,
        _localUserRepository = localUserRepository;

  @override
  Future<Travel> createTravel(Travel travel) async {
    var user = await _localUserRepository.getUser();
    var response = await _dio.post("http://$serverAdr/travels/${user!.id}",
        data: travel.toMap());
    if (response.statusCode == 200) {
      var apiTravel = Travel.fromMap(response.data);
      await _localTravelRepository.createTravel(apiTravel);
      return apiTravel;
    } else {
      await _localTravelRepository.createTravel(travel);
      return travel;
    }
  }

  @override
  Future<bool> deleteTravel(Travel travel) async {
    var response = await _dio.delete("http://$serverAdr/travels/${travel.id}");
    if (response.statusCode == 200) {
      await _localTravelRepository.deleteTravel(travel);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    var user = await _localUserRepository.getUser();
    if (user == null) return [];
    var response = await _dio.get("http://$serverAdr/travels/user/${user.id}");
    if (response.statusCode == 200) {
      var travelMaps = response.data as List<dynamic>;
      List<Travel> travels = [];
      for (var travelMap in travelMaps) {
        travels.add(Travel.fromMap(travelMap));
      }
      var localTravels = await _localTravelRepository.getAllTravels();
      for (var travel in travels) {
        if (localTravels.where((element) => element.city == travel.city && element.days.first == travel.days.first).isEmpty) {
          await _localTravelRepository.createTravel(travel);
        }
      }
      localTravels = await _localTravelRepository.getAllTravels();
      for (var travel in travels) {
        var idx = localTravels.indexOf(localTravels.where((element) => element.city == travel.city && element.days.first == travel.days.first).first);
        if (localTravels[idx].id == null) {
          localTravels[idx].id = travel.id;
          _localTravelRepository.updateTravel(localTravels[idx]);
        }
      }
      return await _localTravelRepository.getAllTravels();
    } else {
      return _localTravelRepository.getAllTravels();
    }
  }

  @override
  Future<Travel?> getTravel(dynamic key) async {
    return _localTravelRepository.getTravel(key);
  }

  @override
  Future<Travel> updateTravel(Travel travel) async {
    await travel.save();
    var user = await _localUserRepository.getUser();
    var response = await _dio.post("http://$serverAdr/travels/${user!.id}",
        data: travel.toMap());
    if (response.statusCode == 200) {
      return travel;
    } else {
      return travel;
    }
  }
}
