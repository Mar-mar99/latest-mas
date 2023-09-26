import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/provider_notification_settings_model.dart';

abstract class ProviderNotificationSettingsDataSource {
  Future<ProviderNotificationSettingsModel> getSettings();
  Future<void> setSettings(ProviderNotificationSettingsModel data);
}

class ProviderNotificationSettingsDataSourceWithHttp
    implements ProviderNotificationSettingsDataSource {
  final BaseApiService client;
  ProviderNotificationSettingsDataSourceWithHttp({required this.client});
  @override
  Future<ProviderNotificationSettingsModel> getSettings() async {
    final res = await client.getRequest(
      url: ApiConstants.getProviderNotificationSettings,
    ) as Map<String, dynamic>;

    return ProviderNotificationSettingsModel.fromJson(res);
  }

  @override
  Future<void> setSettings(ProviderNotificationSettingsModel data) async {
    final res = await client.postRequest(
      url: ApiConstants.setProviderNotificationSettings,
      jsonBody: data.toJson(),
    );
    return;
  }
}
