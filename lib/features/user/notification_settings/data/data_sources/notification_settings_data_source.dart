import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/notification_settings_model.dart';

abstract class NotificationSettingsDataSource {
  Future<NotificationSettingsModel> getSettings();
  Future<void> setSettings(NotificationSettingsModel data);
}

class NotificationSettingsDataSourceWithHttp
    implements NotificationSettingsDataSource {
  final BaseApiService client;
  NotificationSettingsDataSourceWithHttp({required this.client});
  @override
  Future<NotificationSettingsModel> getSettings() async {
    final res = await client.getRequest(
      url: ApiConstants.getNotificationSettings,
    ) as Map<String, dynamic>;

    return NotificationSettingsModel.fromJson(res);
  }

  @override
  Future<void> setSettings(NotificationSettingsModel data) async {
    final res = await client.postRequest(
      url: ApiConstants.setNotificationSettings,
      jsonBody: data.toJson(),
    );
    return;
  }
}
