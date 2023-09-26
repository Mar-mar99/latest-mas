import '../../../../core/api_service/base_api_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/enums/enums.dart';

abstract class DeleteAccountDataSource {
  Future<void> deleteAccount({required TypeAuth typeAuth});
}
class DeleteAccountDataSourceWithHttp extends DeleteAccountDataSource{
  final BaseApiService client;
  DeleteAccountDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<void> deleteAccount({required TypeAuth typeAuth})async {
 var link = '';
    switch (typeAuth) {
      case TypeAuth.user:
        link += ApiConstants.userDeleteAccount;
        break;
      case TypeAuth.company:
        link += ApiConstants.companyDeleteAccount;
        break;
      case TypeAuth.provider:
        link += ApiConstants.providerDeleteAccount;
        break;
    }
    await client.deleteRequest(url: link);
    return;
  }
}
