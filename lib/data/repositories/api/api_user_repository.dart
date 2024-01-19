import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/data/models/user.dart';
import 'package:prepare2travel/data/repositories/local/local_user_repository.dart';
import 'package:prepare2travel/domain/repositories/abstract_user_repository.dart';

class ApiUserRepository extends AbstractUserRepository {
  final Box<User> _userBox;
  final Dio _dio;
  final LocalUserRepository _localUserRepository;

  ApiUserRepository(
      {required Box<User> userBox,
      required Dio dio,
      required LocalUserRepository localUserRepository})
      : _userBox = userBox,
        _dio = dio,
        _localUserRepository = localUserRepository;

  @override
  Future<User?> getUser() async {
    if (_userBox.length > 0) {
      return _userBox.values.first;
    } else {
      return null;
    }
  }

  @override
  Future<bool> updateUser(User user) async {
    //TODO
    return true;
  }

  @override
  Future<User> createUser(User user) async {
    var notFoundError = false;
    Response? response;
    try{
    response = await _dio.get(
      'http://$serverAdr/users/${user.username}',
    );}
    catch(e){
      notFoundError = true;
    }
    if (notFoundError == false&&response!.statusCode == 200) {
      if (response.data['sex'] != user.sex.name) {
        await updateUser(user);
      }
    } else {
      await _dio.post("http://$serverAdr/users/", data: {
        "id": user.id,
        "sex": user.sex.name,
        "username": user.username,
        "email": "string@string.string",
        "password": "string",
        "registeredAt": null,
        "roles": null
      });
    }
    var localUser = await _localUserRepository.getUser();
    if (localUser != null) {
      if (localUser.username != user.username || localUser.sex != user.sex) {
        await _localUserRepository.updateUser(user);
      }
    } else {
      await _localUserRepository.createUser(user);
    }
    return user;
  }
}
