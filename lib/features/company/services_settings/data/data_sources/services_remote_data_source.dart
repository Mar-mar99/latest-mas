// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';

import '../model/cancellation_model.dart';
import '../model/company_provider_model.dart';

import '../model/service_attribute_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ComapnyProviderModel>> getProviders();
  Future<List<ServiceAttributeModel>> getAttributes({
    required int providerId,
    required int serviceId,
  });
  Future<void> saveAttributes({
    required List<Map<String, dynamic>> attributes,
  });
  Future<List<ComapnyProviderModel>> getServiceAssignedProviders({
    required int serviceId,
  });
  Future<void> assignProviderToService({
    required int serviceId,
    required int providerId,
  });
  Future<void> removeProviderFromService({
    required int serviceId,
    required int providerId,
  });
  Future<CancellationModel> getCancellationSettings({
    required int serviceId,
  });
  Future<void> setCancellationSettings({
    required int serviceId,
    required bool hasCancellationFees,
    required double fees,
  });
}

class ServicesRemoteDataSourceWithHttp implements ServicesRemoteDataSource {
  final BaseApiService client;
  ServicesRemoteDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<List<ServiceAttributeModel>> getAttributes({
    required int providerId,
    required int serviceId,
  }) async {
    final data = await client.getRequest(
            url:
                '${ApiConstants.getcompanyServiceAttributes}$providerId/$serviceId')
        as Map<String, dynamic>;
    List<ServiceAttributeModel> attributes = [];
    data['attributes'].forEach((element) {
      attributes.add(ServiceAttributeModel.fromJson(element));
    });
    return attributes;
  }

  @override
  Future<List<ComapnyProviderModel>> getProviders() async {
    final data = await client.getRequest(url: ApiConstants.companiesProviders)
        as Map<String, dynamic>;
    List<ComapnyProviderModel> providers = [];
    data['List'].forEach((element) {
      providers.add(ComapnyProviderModel.fromJson(element));
    });
    return providers;
  }

  @override
  Future<void> saveAttributes({
    required List<Map<String, dynamic>> attributes,
  }) async {
    var body = {"attributez": attributes};

    final data = await client.postRequest(
      url: ApiConstants.saveCompanyAttributes,
      jsonBody: body,
    );

    return;
  }

  @override
  Future<List<ComapnyProviderModel>> getServiceAssignedProviders({
    required int serviceId,
  }) async {
    final data = await client.getRequest(
      url: ApiConstants.getServiceAssignedProvider + '/$serviceId',
    ) as Map<String, dynamic>;
    List<ComapnyProviderModel> providers = [];
    data['Providers'].forEach((element) {
      providers.add(ComapnyProviderModel.fromJson(element));
    });
    return providers;
  }

  @override
  Future<void> assignProviderToService({
    required int serviceId,
    required int providerId,
  }) async {
    final data = await client.postRequest(
      url: ApiConstants.assigneProviderToService,
      jsonBody: {
        "provider": providerId,
        "service": serviceId,
      },
    );
  }

  @override
  Future<void> removeProviderFromService({
    required int serviceId,
    required int providerId,
  }) async {
    final data = await client.postRequest(
      url: ApiConstants.removeProviderToService,
      jsonBody: {
        "provider": providerId,
        "service": serviceId,
      },
    );
  }

  @override
  Future<CancellationModel> getCancellationSettings(
      {required int serviceId}) async {
    final data = await client.getRequest(
      url: ApiConstants.getCancellationSettings + '/$serviceId',
    ) as Map<String, dynamic>;

    return CancellationModel.fromJson(data['Config']);
  }

  @override
  Future<void> setCancellationSettings({
    required int serviceId,
    required bool hasCancellationFees,
    required double fees,
  }) async {
    final data = await client.postRequest(
      url: ApiConstants.setCancellationSettings + '/$serviceId',
      jsonBody: {
        "has_cancelation_fees": hasCancellationFees,
        "cancelation_fees": fees
      },
    );
  }
}
