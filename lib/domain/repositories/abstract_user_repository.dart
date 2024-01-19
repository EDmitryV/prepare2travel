import 'package:prepare2travel/data/models/user.dart';

abstract class AbstractUserRepository {
  Future<User> createUser(User user);
  Future<User?> getUser();
  Future<bool> updateUser(User user);
}
