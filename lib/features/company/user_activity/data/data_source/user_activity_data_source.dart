import 'package:dartz/dartz.dart';
import 'package:masbar/core/api_service/base_api_service.dart';
import 'package:masbar/core/constants/api_constants.dart';

import '../model/expert_activity_model.dart';
import '../model/request_detail_model.dart';
import '../model/service_history_model.dart';

abstract class UserActivityDataSource {
  Future<Tuple2<int, List<UserActivityModel>>> getExpertsActivity({int page = 1});
  Future<List<ServiceHistoryModel>> getExpertUpcomingRequestsForCompany({
    int page = 1,
    DateTime? fromDate,
    DateTime? toDate,
    String? providerId,
  });
  Future<List<ServiceHistoryModel>> getExpertPastRequestsForCompany({
    int page = 1,
    DateTime? fromDate,
    DateTime? toDate,
    String? providerId,
  });
  Future<RequestDetailModel> getRequestDetails({required String id});
}

class UserActivityDataSourceWithHttp implements UserActivityDataSource {
  final BaseApiService client;
  UserActivityDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<Tuple2<int, List<UserActivityModel>>> getExpertsActivity({int page = 1}) async {
    final response = await client.postRequest(
      url: '${ApiConstants.expertsActivityAPI}$page',
      jsonBody: {},
    );
    List<UserActivityModel> data = [];
    response['data'].forEach((c) {
      data.add(UserActivityModel.fromJson(c));
    });

    return Tuple2 (response['total'], data);
  }

  @override
  Future<List<ServiceHistoryModel>> getExpertPastRequestsForCompany({
    int page = 1,
    DateTime? fromDate,
    DateTime? toDate,
    String? providerId,
  }) async {
    Map<String, dynamic> body = {};
    if (fromDate != null && toDate != null) {
      body['fromDate'] = '${fromDate.year}-${fromDate.month}-${fromDate.day}';
      body['toDate'] = '${toDate.year}-${toDate.month}-${toDate.day}';
    }
    if (providerId != null) {
      body['provider_id'] = providerId;
    }
    final response = await client.postRequest(
      url: '${ApiConstants.expertPastRequestsAPI}$page',
      jsonBody: body,
    );
    List<ServiceHistoryModel> data = [];
    response['data'].forEach((c) {
      data.add(ServiceHistoryModel.fromJson(c));
    });

    return data;
  }

  @override
  Future<List<ServiceHistoryModel>> getExpertUpcomingRequestsForCompany({
    int page = 1,
    DateTime? fromDate,
    DateTime? toDate,
    String? providerId,
  }) async {
    Map<String, dynamic> body = {};
    if (fromDate != null && toDate != null) {
      body['fromDate'] = '${fromDate.year}-${fromDate.month}-${fromDate.day}';
      body['toDate'] = '${toDate.year}-${toDate.month}-${toDate.day}';
    }
    if (providerId != null) {
      body['provider_id'] = providerId;
    }
    final response = await client.postRequest(
      url: '${ApiConstants.expertUpcomingRequestsAPI}$page',
      jsonBody: body,
    );
    List<ServiceHistoryModel> data = [];
    response['data'].forEach((c) {
      data.add(ServiceHistoryModel.fromJson(c));
    });

    return data;
  }

  @override
  Future<RequestDetailModel> getRequestDetails({required String id}) async {
    final response = await client.getRequest(
      url: '${ApiConstants.companiesExpertsRequestDetails}/$id',
    );

    return RequestDetailModel.fromJson(response);
  }
}
