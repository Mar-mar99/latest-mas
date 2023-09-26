import 'package:masbar/features/auth/accounts/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<void> saveToken(String token);
  String? getToken();
  Future<bool> hasToken();
  Future<bool> deleteToken();

  Future<void> saveUserData(UserEntity user);
  UserEntity? getUserData();
  Future<bool> hasUserData();
  Future<bool> deleteUserData();
Future<void >updateVerifiedState();

}
