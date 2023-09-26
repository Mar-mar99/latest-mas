// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/history_request_user_model.dart';
import '../model/upcoming_request_user_model.dart';

abstract class UserServiceRecordsDataSource {
  Future<List<HistoryRequestUserModel>> getRequestsHistoryUser(
      {required int page});
  Future<List<UpcomingRequestUserModel>> getRequestsUpcomingUser(
      {required int page});
  Future<void> rate(
      {required int rating,
      required int requestId,
      String comment = '',
      required bool isFav});
}

class UserServiceRecordeDataSourceWithHttp
    implements UserServiceRecordsDataSource {
  final BaseApiService client;
  UserServiceRecordeDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<List<HistoryRequestUserModel>> getRequestsHistoryUser(
      {required int page}) async {
    final res = await client.getRequest(
        url: "${ApiConstants.getRequestsHistoryUser}?page=$page");
    List<HistoryRequestUserModel> data = [];
    res['data'].forEach((c) {
      data.add(HistoryRequestUserModel.fromJson(c));
    });
    return data;
  }

  @override
  Future<List<UpcomingRequestUserModel>> getRequestsUpcomingUser(
      {required int page}) async {
    final res = await client.getRequest(
        url: "${ApiConstants.getRequestsUpcomingUser}?page=$page");
    List<UpcomingRequestUserModel> data = [];
    res['data'].forEach((c) {
      data.add(UpcomingRequestUserModel.fromJson(c));
    });
    return data;
  }

  @override
  Future<void> rate(
      {required int rating,
      required int requestId,
      String comment = '',
      required bool isFav}) async {
    final res = await client.postRequest(
      url: ApiConstants.userRate,
      jsonBody: {
        "request_id": requestId,
        "rating": rating,
        "comment": comment,
        "add2favourite":isFav? true:false
      },
    );

    return;
  }
}
