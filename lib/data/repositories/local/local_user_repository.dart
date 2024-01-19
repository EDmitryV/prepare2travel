import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepare2travel/data/models/user.dart';
import 'package:prepare2travel/domain/repositories/abstract_user_repository.dart';

class LocalUserRepository extends AbstractUserRepository {
  final Box<User> _userBox;

  LocalUserRepository({required Box<User> userBox}) : _userBox = userBox;

  @override
  Future<User> createUser(User user) async {
    await _userBox.add(user);
    return user;
  }

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
    _userBox.clear();
    _userBox.add(user);
    return true;
  }
}
