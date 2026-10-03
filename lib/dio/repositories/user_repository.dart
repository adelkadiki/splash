import 'package:chatapp/dio/models/user.dart';

abstract class UserRepository {
  Future<User> login({required String username, required String password});
  Future<void> logout();
  Future<List<User>> getUsers();
  Future<User> getUser(int id);
  Future<User> updateUser(User user);
  Future<User> createUser(User user);
  Future<void> deleteUser(int id);
}
