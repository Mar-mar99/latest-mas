// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/helpers/decode_response.dart';

import 'package:masbar/features/notification/data/model/notification_model.dart';

import '../../../../core/api_service/base_api_service.dart';
import '../../../../core/api_service/network_service_http.dart';
import '../../../../core/errors/exceptions.dart';

abstract class NotificationDataSource {
  Future<List<NotificationModel>> getNotifications({
    required TypeAuth typeAuth,
    required int page,
  });
  Future<void> deleteNotification(
      {required TypeAuth typeAuth, required int id});
}

class NotificationDataSourceWithHttp extends NotificationDataSource {
  final BaseApiService client;
  NotificationDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<List<NotificationModel>> getNotifications({
    required TypeAuth typeAuth,
    required int page,
  }) async {
    String url = (typeAuth == TypeAuth.user)
        ? '${ApiConstants.userNotifications}?page=$page'
        : '${ApiConstants.providerNotifications}?page=$page';

    final response = await client.getRequest(url: url);
    List<NotificationModel> notifications = [];
    response['data'].forEach((c) {
      notifications.add(NotificationModel.fromJson(c));
    });
    return notifications;
  }

  @override
  Future<void> deleteNotification(
      {required TypeAuth typeAuth, required int id}) async {
    String url = (typeAuth == TypeAuth.user)
        ? "${ApiConstants.userDeleteNotification}$id"
        : "${ApiConstants.providerDeleteNotification}$id";

    final response = await client.getRequest(url: url);
    return;
  }
}
