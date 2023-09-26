import 'package:masbar/core/utils/services/shared_preferences.dart';
import 'package:masbar/features/auth/accounts/data/models/user_model.dart';
import 'package:masbar/features/auth/accounts/domain/entities/user_entity.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  static const _tokenKey = 'TOKEN';
  static const _userDataKey = 'user';
  @override
  Future<void> saveToken(String token) async {
    await PreferenceUtils.setString(_tokenKey, token);
  }

  @override
  String? getToken() {
    return PreferenceUtils.getString(_tokenKey);
  }

  @override
  Future<bool> hasToken() async {
    return PreferenceUtils.hasValue(_tokenKey);
  }

  @override
  Future<bool> deleteToken() async {
    return await PreferenceUtils.removeValue(_tokenKey);
  }

  @override
  Future<bool> deleteUserData() async {
    return await PreferenceUtils.removeValue(_userDataKey);
  }

  @override
  UserEntity getUserData() {
    Map<String, dynamic> data =
        PreferenceUtils.getObject(_userDataKey) as Map<String, dynamic>;
    UserEntity userEntity = UserModel.fromJson(data);
    return userEntity;
  }

  @override
  Future<bool> hasUserData() {
    return PreferenceUtils.hasValue(_userDataKey);
  }

  @override
  Future<void> saveUserData(UserEntity user) async {
   
    await PreferenceUtils.setObject(_userDataKey, (user as UserModel).toJson());
  }

  @override
  Future<void> updateVerifiedState() async {
    UserModel currentData = getUserData() as UserModel;
    UserModel newData = currentData.copyWith(verified: 1);
    saveUserData(newData);
  }
}
