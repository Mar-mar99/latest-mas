// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dartz/dartz.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';
import 'dart:io';
import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/api_service/network_service_dio.dart';
import '../../../../../core/api_service/network_service_http.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../model/category_model.dart';
import '../model/created_request_result_model.dart';
import '../model/request_details_model.dart';
import '../model/request_service_model.dart';
import '../model/service_info_model.dart';
import '../model/service_model.dart';
import '../model/service_provider_model.dart';

abstract class ExploreServicesDataSource {
  Future<List<ServiceModel>> getCategoryServices({required int categoryId});
  Future<List<ServiceModel>> searchServes({
    int? categoryId,
    required String text,
    String type = '',
    double distance = 0,
  });
  Future<ServiceInfoModel> getServiceDetails({
    required int serviceId,
    required int stateId,
  });
  Future<CreatedRequestResultModel> createService({
    required RequestServiceModel requestServiceModel,
    List<File>? images,
  });
  Future<void> cancelRequest({
    required int id,
    required String reason,
  });
  Future<RequestDetailsModel> getRequestDetails({
    required int id,
  });
  Future<int?> getPending();
  Future<int?> getActive();
  Future<List<CategoryModel>> getCategories();
  Future<
      Tuple4<List<ServiceProviderModel>, List<ServiceProviderModel>,
          List<ServiceProviderModel>, int>> searchServiceProviders(
      {required int state,
      required double lat,
      required double lng,
      required String address,
      required int serviceType,
      required ServicePaymentType paymentStatus,
      required PaymentMethod paymentMethod,
      required int distance,
      DateTime? scheduleDate,
      DateTime? scheduleTime,
      String? notes,
      String? promoCode,
      List<Tuple2<int, dynamic>>? selectedAttributes,
      List<File>? images});

  Future<void> requestOnlineProvider(
      {required int providerId,
      required int requestId,
      DateTime? scheduleDate,
      DateTime? scheduleTime,
      List<File>? images,
      String? notes});
  Future<void> requestOfflineProvider(
      {required int providerId,
      required int requestId,
      required DateTime scheduleDate,
      required DateTime scheduleTime,
      List<File>? images,
      String? notes});
  Future<void> requestBusyProvider(
      {required int providerId,
      required int requestId,
      required DateTime scheduleDate,
      required DateTime scheduleTime,
      List<File>? images,
      String? notes});
  Future<void> acceptProviderSchedule({
    required int providerId,
    required int requestId,
  });
}

class ExploreServicesDataSourceWithHttp implements ExploreServicesDataSource {
  final BaseApiService client;
  ExploreServicesDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<List<ServiceModel>> getCategoryServices(
      {required int categoryId}) async {
    final res = await client.postRequest(
      url: ApiConstants.getAllServiceAPI,
      jsonBody: {
        'category_id': categoryId,
      },
    );
    List<ServiceModel> data = [];

    res.forEach((element) {
      data.add(ServiceModel.fromJson(element));
    });
    return data;
  }

  @override
  Future<ServiceInfoModel> getServiceDetails(
      {required int serviceId, required int stateId}) async {
    final response = await client.getRequest(
      url: '${ApiConstants.getServiceInfoAPI}$stateId/$serviceId',
    );

    ServiceInfoModel serviceInfoModel =
        ServiceInfoModel.fromJson((response['service']));

    return serviceInfoModel;
  }

  @override
  Future<List<ServiceModel>> searchServes({
    int? categoryId,
    required String text,
    String type = '',
    double distance = 0,
  }) async {
    Map<String, dynamic> jsonBody = {
      'keyword': text.toString(),
    };
    if (categoryId != null) {
      jsonBody['category_id'] = categoryId;
    }
    if (type.isNotEmpty) {
      jsonBody['type'] = type;
    }
    if (distance != 0) {
      jsonBody['distance'] = distance;
    }
    final res = await client.postRequest(
        url: ApiConstants.getAllServiceAPI, jsonBody: jsonBody);
    List<ServiceModel> data = [];

    res.forEach((element) {
      data.add(ServiceModel.fromJson(element));
    });
    return data;
  }

  @override
  Future<CreatedRequestResultModel> createService({
    required RequestServiceModel requestServiceModel,
    List<File>? images,
  }) async {
    var body = requestServiceModel.toJson();

    NetworkServiceDio networkServiceDio = NetworkServiceDio();

    final response = await networkServiceDio.multipartRequest(
        url: ApiConstants.requestsService,
        jsonBody: body,
        attributeName: 'images[]',
        files: images);
    var data = CreatedRequestResultModel.fromJson(response);
    return data;
  }

  @override
  Future<void> cancelRequest({required int id, required String reason}) async {
    final res = await client.postRequest(
      url: ApiConstants.cancelRequests,
      jsonBody: {"request_id": id, "reason": reason},
    );
  }

  @override
  Future<RequestDetailsModel> getRequestDetails({required int id}) async {
    final res = await client.getRequest(
      url: '${ApiConstants.requestDetails}/$id',
    );
    return RequestDetailsModel.fromJson(res);
  }

  @override
  Future<int?> getActive() async {
    try {
      final res =
          await client.getRequest(url: "${ApiConstants.currentActiveRequest}");

      if (res == null) {
        return null;
      } else if ((res is Map) && (res as Map).isNotEmpty) {
        return res['id'];
      } else if ((res is List) && (res as List).isEmpty) {
        return null;
      }
    } on ExceptionFormat {
      return null;
    }
  }

  @override
  Future<int?> getPending() async {
    try {
      final res =
          await client.getRequest(url: "${ApiConstants.pendingRequests}");
      if (res == null) {
        return null;
      }
      return res['id'];
    } on ExceptionFormat {
      return null;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.getRequest(
      url: '${ApiConstants.getCategories}',
    );
    List<CategoryModel> data = [];
    for (Map<String, dynamic> element in response) {
      CategoryModel categoryModel = CategoryModel.fromJson((element));
      data.add(categoryModel);
    }
    return data;
  }

  @override
  Future<
      Tuple4<List<ServiceProviderModel>, List<ServiceProviderModel>,
          List<ServiceProviderModel>, int>> searchServiceProviders(
      {required int state,
      required double lat,
      required double lng,
      required String address,
      required int serviceType,
      required ServicePaymentType paymentStatus,
      required PaymentMethod paymentMethod,
      required int distance,
      DateTime? scheduleDate,
      DateTime? scheduleTime,
      String? notes,
      String? promoCode,
      List<Tuple2<int, dynamic>>? selectedAttributes,
      List<File>? images}) async {
    var jsonBody = {
      'state_id': state,
      's_latitude': lat,
      's_longitude': lng,
      's_address': address,
      'service_type': serviceType,
      'payment_mode': (paymentStatus == ServicePaymentType.paid)
          ? paymentMethod.getText().toUpperCase()
          : "FREE",
      'distance': distance,
      if (scheduleDate != null)
        'schedule_date': DateFormat('yyyy-MM-dd').format(scheduleDate),
      if (scheduleTime != null)
        'schedule_time': DateFormat('kk:mm').format(scheduleTime),
      if (promoCode != null) 'promo_code': promoCode,
      if (notes != null) 'notes': notes
    };
    if (selectedAttributes != null) {
      for (int i = 0; i < selectedAttributes.length; i++) {
        jsonBody
            .addAll({"attributez[$i][attr_id]": selectedAttributes[i].value1});
        jsonBody.addAll({
          "attributez[$i][attr_value]": selectedAttributes[i].value2 as String
        });
      }
    }

    NetworkServiceDio networkServiceDio = NetworkServiceDio();

    final res = await networkServiceDio.multipartRequest(
        url: ApiConstants.searchServiceProviders,
        jsonBody: jsonBody,
        attributeName: 'images[]',
        files: images);

    List<ServiceProviderModel> online = [];
    for (Map<String, dynamic> element in res['List']['Online']) {
      ServiceProviderModel p = ServiceProviderModel.fromJson((element));
      online.add(p);
    }

    List<ServiceProviderModel> offline = [];
    for (Map<String, dynamic> element in res['List']['Offline']) {
      ServiceProviderModel p = ServiceProviderModel.fromJson((element));
      offline.add(p);
    }

    List<ServiceProviderModel> busy = [];
    for (Map<String, dynamic> element in res['List']['Busy']) {
      ServiceProviderModel p = ServiceProviderModel.fromJson((element));
      busy.add(p);
    }
    return Tuple4(online, offline, busy, res['request_id']);
  }

  @override
  Future<void> requestBusyProvider(
      {required int providerId,
      required int requestId,
      required DateTime scheduleDate,
      required DateTime scheduleTime,
      List<File>? images,
      String? notes}) async {
    String date = DateFormat('yyyy-MM-dd').format(scheduleDate);
    String time = DateFormat('kk:mm').format(scheduleTime);
    var jsonBody = {
      "provider_id": providerId,
      "request_id": requestId,
      "schedule_date_time": '$date $time',
      if (notes != null) 'notes': notes
    };
    NetworkServiceDio networkServiceDio = NetworkServiceDio();

    final res = await networkServiceDio.multipartRequest(
        url: ApiConstants.requestBusyProviders,
        jsonBody: jsonBody,
        attributeName: 'images[]',
        files: images);
  }

  @override
  Future<void> requestOfflineProvider(
      {required int providerId,
      required int requestId,
      required DateTime scheduleDate,
      required DateTime scheduleTime,
      List<File>? images,
      String? notes}) async {
    String date = DateFormat('yyyy-MM-dd').format(scheduleDate);
    String time = DateFormat('kk:mm').format(scheduleTime);
    var jsonBody = {
      "provider_id": providerId,
      "request_id": requestId,
      "schedule_date_time": '$date $time',
      if (notes != null) 'notes': notes
    };
    NetworkServiceDio networkServiceDio = NetworkServiceDio();

    final res = await networkServiceDio.multipartRequest(
        url: ApiConstants.requestOfflineProviders,
        jsonBody: jsonBody,
        attributeName: 'images[]',
        files: images);
  }

  @override
  Future<void> requestOnlineProvider(
      {required int providerId,
      required int requestId,
      DateTime? scheduleDate,
      DateTime? scheduleTime,
      List<File>? images,
      String? notes}) async {
    String date = '';
    String time = '';
    if (scheduleDate != null && scheduleTime != null) {
      date = DateFormat('yyyy-MM-dd').format(scheduleDate);
      time = DateFormat('kk:mm').format(scheduleTime);
    }
     var jsonBody = {
      "provider_id": providerId,
      "request_id": requestId,
      "schedule_date_time": '$date $time',
      if (notes != null) 'notes': notes
    };
    NetworkServiceDio networkServiceDio = NetworkServiceDio();

    final res = await networkServiceDio.multipartRequest(
        url: ApiConstants.requestOnlineProviders,
        jsonBody: jsonBody,
        attributeName: 'images[]',
        files: images);
  
  }

  @override
  Future<void> acceptProviderSchedule({
    required int providerId,
    required int requestId,
  }) async {
    final res = await client.postRequest(
      url: ApiConstants.acceptProviderSechdule,
      jsonBody: {
        "provider_id": providerId,
        "request_id": requestId,
      },
    );
  }
}
