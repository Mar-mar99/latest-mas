// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums/enums.dart';

class UserEntity extends Equatable {
 final int? id;
 final dynamic companyId;
 final String? firstName;
 final dynamic lastName;
 final String? email;
 final int? stateId;
 final String? phoneCode;
 final String? mobile;
 final String? picture;
 final dynamic description;
 final dynamic? rating;
 final String? status;
 final dynamic latitude;
 final dynamic longitude;
 final dynamic? ratingCount;
 final dynamic? otp;
 final dynamic? verified;
 final dynamic stripeAccId;
 final int? isStripeinfoFilled;
 final int? isStripeConnected;
 final String? type;
 final int? providersCount;
 final dynamic? commission;
 final int? local;
 final String? address;
 final String? expertActive;
 final String? accessToken;
 final String? currency;
 final UserLoginType? loginBy;
 final ServiceEntity? service;
 final DeviceEntity? device;
 final dynamic walletBalance;
 final int? activeRequest;

  UserEntity(
      {this.id,
      this.companyId,
      this.firstName,
      this.lastName,
      this.email,
      this.stateId,
      this.phoneCode,
      this.mobile,
      this.picture,
      this.description,
      this.rating,
      this.status,
      this.latitude,
      this.longitude,
      this.ratingCount,
      this.walletBalance,
      this.otp,
      this.verified,
      this.stripeAccId,
      this.isStripeinfoFilled,
      this.isStripeConnected,
      this.type,
      this.providersCount,
      this.commission,
      this.local,
      this.address,
      this.expertActive,
      this.accessToken,
      this.currency,
      this.loginBy,
      this.service,
      this.device,
      this.activeRequest});

  @override
  List<Object?> get props => [
        id,
        companyId,
        firstName,
        lastName,
        email,
        stateId,
        phoneCode,
        mobile,
        picture,
        description,
        rating,
        status,
        latitude,
        longitude,
        ratingCount,
        walletBalance,
        otp,
        verified,
        stripeAccId,
        isStripeinfoFilled,
        isStripeConnected,
        type,
        providersCount,
        commission,
        loginBy,
        local,
        address,
        expertActive,
        accessToken,
        currency,
        service,
        device,
        activeRequest
      ];

  @override
  bool get stringify => true;


}

class ServiceEntity extends Equatable {
 final int? id;
 final int? providerId;
 final int? serviceTypeId;
 final String? status;
 final dynamic serviceNumber;
 final dynamic serviceModel;

  ServiceEntity(
      {this.id,
      this.providerId,
      this.serviceTypeId,
      this.status,
      this.serviceNumber,
      this.serviceModel});

  @override
  List<Object?> get props => [
        id,
        providerId,
        serviceTypeId,
        status,
        serviceNumber,
        serviceModel,
      ];
}

class DeviceEntity extends Equatable {
 final int? id;
 final int? providerId;
 final String? udid;
 final String? token;
 final dynamic snsArn;
 final String? type;

  DeviceEntity(
      {this.id,
      this.providerId,
      this.udid,
      this.token,
      this.snsArn,
      this.type});

  @override
  List<Object?> get props => [
        id,
        providerId,
        udid,
        token,
        snsArn,
        type,
      ];
}
