import 'package:masbar/core/constants/api_constants.dart';

import '../../../../../core/api_service/base_api_service.dart';
import '../models/payment_method_model.dart';

abstract class PaymentDataSource {
  Future<List<PaymentsMethodModel>> getPaymentsMethods();
  Future<void> addCard({required String cardToken});
  Future<void> setDefaultPaymentMethod({required int cardId});
  Future<void> deleteCard({required String id});
}

class PaymentDataSourWithHttp implements PaymentDataSource {
  final BaseApiService client;
  PaymentDataSourWithHttp({
    required this.client,
  });
  @override
  Future<List<PaymentsMethodModel>> getPaymentsMethods() async {
    final res = await client.getRequest(url: ApiConstants.userCard);
    List<PaymentsMethodModel> cards = [];

    res.forEach((c) {
      cards.add(PaymentsMethodModel.fromJson(c));
    });
    return cards;
  }

  @override
  Future<void> addCard({required String cardToken}) async {
    final res = await client.postRequest(
      url: ApiConstants.userCard,
      jsonBody: {
        "stripe_token": cardToken,
        "is_default": 0,
      },
    );
    return;
  }

  @override
  Future<void> deleteCard({required String id}) async {
    final res = await client.deleteRequest(url: '${ApiConstants.deleteCardAPI}$id');
    return;
  }

  @override
  Future<void> setDefaultPaymentMethod({required int cardId}) async {
    final res = await client.postRequest(
      url: ApiConstants.setDefaultCardAPI,
      jsonBody: {
        "card_id": cardId,
      },
    );
    return;
  }
}
