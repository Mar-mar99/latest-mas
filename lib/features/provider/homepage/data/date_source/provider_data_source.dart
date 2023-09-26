import 'dart:io';

import '../../../../../core/api_service/base_api_service.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:intl/intl.dart';
import '../model/invoice_model.dart';
import '../model/offline_request_model.dart';
import '../model/request_provider_model.dart';

abstract class ProviderDataSource {
  Future<void> submitProviderLocation({
    required double lat,
    required double lng,
  });
  Future<void> goOnlineOrOffline({
    required bool goOnline,
  });
  Future<void> getIncomingRequestDetails({required int requestId});
  Future<void> acceptRequest({
    required int id,
  });
  Future<void> rejectRequest({
    required int id,
  });
  Future<RequestProviderModel> getRequestDetails({required int requestId});

  Future<RequestProviderModel?> currentRequestsApi();
  Future<void> arrivedToLocation({
    required int id,
  });
  Future<void> cancelAfterAccept({
    required int id,
    required String reason,
  });
  Future<void> startWorkingOnTheService({
    required int id,
  });
  Future<InvoiceModel> finishWorkingOnTheService({
    required int requestId,
    List<File>? images,
    String? comment,
  });
  Future<void> recieveCash({
    required int id,
  });
  Future<void> suggestAnotherTime(
      {required int requestId, required DateTime date, required DateTime time});

  Future<List<OfflineRequestModel>> fetchOfflineRequests();
}

class ProviderDataSourceWithHttp implements ProviderDataSource {
  final BaseApiService client;
  ProviderDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<void> goOnlineOrOffline({required bool goOnline}) async {
    final res = await client.getRequest(
      url: goOnline
          ? ApiConstants.providerGoOnline
          : ApiConstants.providerGoOffline,
    );
    return;
  }

  @override
  Future<void> submitProviderLocation(
      {required double lat, required double lng}) async {
    final res = await client.postRequest(
      url: ApiConstants.providerLocation + '',
      jsonBody: {
        'latitude': lat,
        'longitude': lng,
      },
    );
    return;
  }

  @override
  Future<RequestProviderModel> getIncomingRequestDetails(
      {required int requestId}) async {
    final res = await client.getRequest(
        url: '${ApiConstants.incomingRequestDetails}/$requestId');
    final data = RequestProviderModel.fromJson(res);
    return data;
  }

  @override
  Future<void> acceptRequest({required int id}) async {
    final res = await client.getRequest(
        url: "${ApiConstants.providerAcceptRequest}/$id");
    return;
  }

  @override
  Future<void> rejectRequest({required int id}) async {
    final res = await client.getRequest(
        url: "${ApiConstants.providerRejectRequest}/$id");
    return;
  }

  @override
  Future<RequestProviderModel?> currentRequestsApi() async {
    final response = await client.getRequest(url: ApiConstants.currentRequests);
    if (response != null && response.runtimeType != List) {
      final data = RequestProviderModel.fromJson(response);
      return data;
    } else if (response.runtimeType == List) {
      return null;
    }
  }

  @override
  Future<void> arrivedToLocation({required int id}) async {
    final res = await client.getRequest(
      url: "${ApiConstants.providerArrived}/$id",
    );
    return;
  }

  @override
  Future<void> cancelAfterAccept(
      {required int id, required String reason}) async {
    final res = await client.postRequest(
      url: ApiConstants.providerCancelAfterAccept,
      jsonBody: {"request_id": id, "reason": reason},
    );
    return;
  }

  @override
  Future<InvoiceModel> finishWorkingOnTheService(
      {required int requestId, List<File>? images, String? comment}) async {
    final res = await client.multipartRequest(
      attributeName: 'images[]',
      files: images,
      url: ApiConstants.providerFinishWorkingOnTheService,
      jsonBody: {"request_id": requestId, "reason": comment},
    );
    final data = InvoiceModel.fromJson(res);

    return data;
  }

  @override
  Future<void> startWorkingOnTheService({required int id}) async {
    final res = await client.getRequest(
      url: '${ApiConstants.providerStartWorkingOnTheService}/$id',
    );
    return;
  }

  @override
  Future<void> recieveCash({required int id}) async {

    final res = await client.getRequest(
      url: "${ApiConstants.markCashPaid}/$id",
    );
    return;
  }

  @override
  Future<RequestProviderModel> getRequestDetails(
      {required int requestId}) async {
    final response = await client.getRequest(
        url: ApiConstants.providerRequestDetails + '/$requestId');
    return RequestProviderModel.fromJson(response);
  }

  @override
  Future<void> suggestAnotherTime({
    required int requestId,
    required DateTime date,
    required DateTime time,
  }) async {
    String d = DateFormat('yyyy-MM-dd').format(date);
    String t = DateFormat('kk:mm').format(time);
    final response = await client.postRequest(
        url: ApiConstants.suggestAnotherTime,
        jsonBody: {"request_id": requestId, "schedule_date_time": "$d $t"});
    return;
  }

  @override
  Future<List<OfflineRequestModel>> fetchOfflineRequests()async {
   final res = await client.getRequest(
      url: ApiConstants.offlineRequest,
    );
    List<OfflineRequestModel> data=[];
    for(var e in res['List']){
      data.add(OfflineRequestModel.fromJson(e));
    }
   return data;


  }
}
