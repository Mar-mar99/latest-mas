// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/api_service/base_api_service.dart';


abstract class EditPasswordDataSource {
  Future<void> updatePassword(
      {required String oldPassword,
      required String password,
      required String passwordConfirmation,
      required TypeAuth typeAuth});
}

class EditPasswordDataSourceWithHttp extends EditPasswordDataSource {
  final BaseApiService client;
  EditPasswordDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<void> updatePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
    required TypeAuth typeAuth,
  }) async {
    var link = '';
    switch (typeAuth) {
      case TypeAuth.user:
        link += ApiConstants.changePassword;
        break;
      case TypeAuth.company:
        link += ApiConstants.companiesProfileChangePassword;
        break;
      case TypeAuth.provider:
        link += ApiConstants.providerProfileChangePassword;
        break;
    }
    final data = await client.postRequest(
      url: link,
      jsonBody: {
        "old_password": oldPassword,
        "password": password,
        "password_confirmation": passwordConfirmation
      },
    );

    return;
  }
}
