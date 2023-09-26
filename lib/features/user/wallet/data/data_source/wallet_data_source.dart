import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/wallet_model.dart';

abstract class WalletDataSource {
  Future<List<WalletModel>> getWallet();
  Future<void> chargeWallet({required String amount, required int cardId});
}

class WalletDataSourceWithHttp implements WalletDataSource {
  final BaseApiService client;
  WalletDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<void> chargeWallet(
      {required String amount, required int cardId}) async {
    final response = await client.postRequest(
        url: ApiConstants.addWalletApi,
        jsonBody: {"amount": amount, "card_id": cardId});

    return;
  }

  @override
  Future<List<WalletModel>> getWallet() async {
    final response = await client.getRequest(url: ApiConstants.getWalletApi);
    List<WalletModel> wallet = [];

    response['wallet_history'].forEach((c) {
      wallet.add(WalletModel.fromJson(c));
    });
    return wallet;
  }
}
