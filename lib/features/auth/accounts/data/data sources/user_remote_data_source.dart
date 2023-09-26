import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';
import 'package:masbar/core/utils/helpers/decode_response.dart';
import 'package:masbar/features/auth/accounts/domain/entities/social_user_entity.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/login_usecase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> socialLogin(
      {required SocialUserEntity socialUserEntity,
      required int state,
      required SocialLoginType loginType});
  Future<UserModel> signupProvider({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String code,
    required String password,
    required String confirmPassword,
    required List<File> documents,
  });
  Future<UserModel> signupCompany({
    required CompanyOwnerType companyOwnerType,
    required String companyName,
    required String email,
    required String phone,
    required List<int> state,
    required int mainBranch,
    required int providerCount,
    required String address,
    required String password,
    required String confirmPassword,
    required List<File> documents,
    required VerifyByType verifyByType,
  });
  Future<UserModel> signupUser(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone,
      required int state});
  Future<UserModel> loggin(
    String email,
    String password,
    LoginUserType type,
  );
  Future<UserModel> getUserData({
    required TypeAuth typeAuth,
  });
  Future<void> logOut({
    required TypeAuth typeAuth,
  });
}

class UserRemoteDataSourceWithHttp implements UserRemoteDataSource {
  final BaseApiService client;
  UserRemoteDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<UserModel> signupUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required int state,
  }) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> body = {
      "login_by": "manual",
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "mobile": phone,
      "device_type": Platform.isAndroid ? 'android' : 'ios',
      "device_token": deviceToken ?? '00',
      "device_id": "00",
      "state": state
    };
    final decodedResponse = await client.postRequest(
      url: ApiConstants.register,
      jsonBody: body,
    );

    return UserModel.fromJson(decodedResponse);
  }

  @override
  Future<UserModel> signupCompany({
    required CompanyOwnerType companyOwnerType,
    required String companyName,
    required String email,
    required String phone,
    required List<int> state,
    required int mainBranch,
    required int providerCount,
    required String address,
    required String password,
    required String confirmPassword,
    required List<File> documents,
    required VerifyByType verifyByType,
  }) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();

    Map<String, dynamic> body = {
      'first_name': companyName,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'phone_code': '+971',
      'mobile': phone,
      'address': address,
      'commission': '',
      'local': companyOwnerType.getNumeber(),
      'device_id': 00,
      "device_type": Platform.isAndroid ? 'android' : 'ios',
      'device_token': deviceToken ?? 'device_token',
      'providers_count': providerCount,
      //  'documents[]': [...docsFile],
      //'state[]': state,
      'main_branch': mainBranch,
      'verify_by': verifyByType.getText()
    };
    for (int i = 0; i < state.length; i++) {
      body.addAll({"state[$i]": state[i]});
    }
    final res = await client.multipartRequest(
        url: ApiConstants.registerCompany,
        jsonBody: body,
        attributeName: 'documents[]',
        files: documents);
    return UserModel.fromJson(res);
  }

  @override
  Future<UserModel> loggin(
    String email,
    String password,
    LoginUserType type,
  ) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    var loginType = type == LoginUserType.user
        ? ApiConstants.login
        : ApiConstants.loginCompany;
    final decodedResponse = await client.postRequest(url: loginType, jsonBody: {
      "username": email,
      "password": password,
      "device_type": Platform.isAndroid ? 'android' : 'ios',
      "device_token": deviceToken ?? '',
      'device_id': "1234567890"
    });
    return UserModel.fromJson(decodedResponse);
  }

  @override
  Future<UserModel> signupProvider({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String code,
    required String password,
    required String confirmPassword,
    required List<File> documents,
  }) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();

    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': phone,
      'password': password,
      'password_confirmation': password,
      // 'profile_image':'',
      'phone_code': '+971',
      'device_id': 00,
      'device_type': Platform.isAndroid ? 'android' : 'ios',
      'device_token': deviceToken ?? 'device_token',
      'code': code,
    };
    final res = await client.multipartRequest(
        url: ApiConstants.registerProvider,
        jsonBody: body,
        attributeName: 'documents[]',
        files: documents);
    return UserModel.fromJson(res);
  }

  @override
  Future<UserModel> socialLogin(
      {required SocialUserEntity socialUserEntity,
      required int state,
      required SocialLoginType loginType}) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    final res =
        await client.postRequest(url: ApiConstants.socialLogin, jsonBody: {
      "first_name": socialUserEntity.firstName,
      "last_name": socialUserEntity.lastName,
      "email": socialUserEntity.email,
      "avatar": socialUserEntity.photo,
      "device_token": deviceToken,
      "device_type": Platform.isAndroid ? 'android' : 'ios',
      "login_by": loginType.getText(),
      "social_unique_id": socialUserEntity.id,
      "state": state
    });

    return UserModel.fromJson(res);
  }

  @override
  Future<UserModel> getUserData({
    required TypeAuth typeAuth,
  }) async {
    String url = '';
    switch (typeAuth) {
      case TypeAuth.user:
        url = ApiConstants.getUserData;
        break;
      case TypeAuth.company:
        url = ApiConstants.getCompaniesData;
        break;
      case TypeAuth.provider:
        url = ApiConstants.providerProfile;
        break;
    }

    final decodedResponse = await client.getRequest(url: url);

    return UserModel.fromJson(decodedResponse);
  }

  @override
  Future<void> logOut({required TypeAuth typeAuth}) async {
    String url = '';
    switch (typeAuth) {
      case TypeAuth.user:
        url = ApiConstants.userLogout;
        break;
      case TypeAuth.company:
        url = ApiConstants.companiesLogout;
        break;
      case TypeAuth.provider:
        url = ApiConstants.providerLogout;
        break;
    }

    final decodedResponse = await client.postRequest(url: url, jsonBody: {});

    return;
  }
}
