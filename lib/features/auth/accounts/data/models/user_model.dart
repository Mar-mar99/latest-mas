import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {super.id,
      super.companyId,
      super.firstName,
      super.lastName,
      super.email,
      super.stateId,
      super.phoneCode,
      super.mobile,
      super.picture,
      super.description,
      super.rating,
      super.status,
      super.latitude,
      super.longitude,
      super.ratingCount,
      super.walletBalance,
      super.otp,
      super.verified,
      super.stripeAccId,
      super.isStripeinfoFilled,
      super.isStripeConnected,
      super.type,
      super.providersCount,
      super.commission,
      super.local,
      super.address,
      super.loginBy,
      super.expertActive,
      super.accessToken,
      super.currency,
      super.service,
      super.device,
      super.activeRequest});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        companyId: json['company_id'] ?? '',
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'] ?? '',
        stateId: json['state_id'] ?? 1,
        phoneCode: json['phone_code'] ?? '',
        mobile: json['mobile'] ?? '',
        walletBalance: json['wallet_balance'],
        picture: json['picture'] ?? json['avatar'] ?? '',
        description: json['description'] ?? '',
        rating: json['rating'] ?? '',
        status: json['status'] ?? '',
        latitude: json['latitude'] ?? '',
        longitude: json['longitude'] ?? '',
        ratingCount: json['rating_count'] ?? '',
        otp: json['otp'] ?? 1,
        verified: json['verified'] ?? 1,
        stripeAccId: json['stripe_acc_id'] ?? '',
        isStripeinfoFilled: json['is_stripeinfo_filled'] ?? 0,
        isStripeConnected: json['is_stripe_connected'] ?? 0,
        type: json['type'] ?? '',
        providersCount: json['providers_count'] ?? 0,
        commission: json['commission'] ?? 0,
        local: json['local'] ?? 0,
        address: json['address'] ?? '',
        expertActive: json['expertActive'] ?? '',
        accessToken: json['access_token'] ?? json['token'],
        currency: json['currency'] ?? '',
        activeRequest: json['ActiveRequest'],
        loginBy: json['login_by'] != null
            ?    json['login_by'] == 'manual'
                ? UserLoginType.manual
                : UserLoginType.social
            : null,
        service: json['service'] != null
            ? ServiceModel.fromJson(json['service'])
            : null,
        device: json['device'] != null
            ? DeviceModel.fromJson(json['device'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_code'] = phoneCode;
    data['mobile'] = mobile;
    data['avatar'] = picture;
    data['description'] = description;
    data['rating'] = rating;
    data['status'] = status;
    data['state_id'] = stateId;
    data['wallet_balance'] = walletBalance;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['rating_count'] = ratingCount;
    data['otp'] = otp;
    data['verified'] = verified;
    data['stripe_acc_id'] = stripeAccId;
    data['is_stripeinfo_filled'] = isStripeinfoFilled;
    data['is_stripe_connected'] = isStripeConnected;
    data['type'] = type;
    data['providers_count'] = providersCount;
    data['commission'] = commission;
    data['local'] = local;
    data['address'] = address;
    data['expertActive'] = expertActive;
    data['access_token'] = accessToken;
    data['currency'] = currency;
    data['login_by']= loginBy!=null? loginBy== UserLoginType.manual?'manual':'social':null;
    if (service != null) {
      data['service'] = (service as ServiceModel).toJson();
    }
    if (device != null) {
      data['device'] = (device as DeviceModel).toJson();
    }
    return data;
  }

  UserModel copyWith({
    int? id,
    dynamic? companyId,
    String? firstName,
    dynamic? lastName,
    String? email,
    int? stateId,
    String? phoneCode,
    String? mobile,
    String? picture,
    dynamic? description,
    dynamic? rating,
    String? status,
    dynamic? latitude,
    dynamic? longitude,
    dynamic? ratingCount,
    dynamic? otp,
    dynamic? verified,
    dynamic? stripeAccId,
    int? isStripeinfoFilled,
    int? isStripeConnected,
    String? type,
    int? providersCount,
    dynamic? commission,
    int? local,
    String? address,
    String? expertActive,
    String? accessToken,
    String? currency,
    ServiceEntity? service,
    DeviceEntity? device,
    dynamic? walletBalance,
    int? activeRequest,
  }) {
    return UserModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      stateId: stateId ?? this.stateId,
      phoneCode: phoneCode ?? this.phoneCode,
      mobile: mobile ?? this.mobile,
      picture: picture ?? this.picture,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ratingCount: ratingCount ?? this.ratingCount,
      otp: otp ?? this.otp,
      verified: verified ?? this.verified,
      stripeAccId: stripeAccId ?? this.stripeAccId,
      isStripeinfoFilled: isStripeinfoFilled ?? this.isStripeinfoFilled,
      isStripeConnected: isStripeConnected ?? this.isStripeConnected,
      type: type ?? this.type,
      providersCount: providersCount ?? this.providersCount,
      commission: commission ?? this.commission,
      local: local ?? this.local,
      address: address ?? this.address,
      expertActive: expertActive ?? this.expertActive,
      accessToken: accessToken ?? this.accessToken,
      currency: currency ?? this.currency,
      service: service ?? this.service,
      device: device ?? this.device,
      walletBalance: walletBalance ?? this.walletBalance,
      activeRequest: activeRequest ?? this.activeRequest,
    );
  }
}

class ServiceModel extends ServiceEntity {
  ServiceModel(
      {super.id,
      super.providerId,
      super.serviceTypeId,
      super.status,
      super.serviceNumber,
      super.serviceModel});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        id: json['id'],
        providerId: json['provider_id'],
        serviceTypeId: json['service_type_id'],
        status: json['status'],
        serviceNumber: json['service_number'],
        serviceModel: json['service_model']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['service_type_id'] = serviceTypeId;
    data['status'] = status;
    data['service_number'] = serviceNumber;
    data['service_model'] = serviceModel;
    return data;
  }

  ServiceModel copyWith({
    int? id,
    int? providerId,
    int? serviceTypeId,
    String? status,
    dynamic? serviceNumber,
    dynamic? serviceModel,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      status: status ?? this.status,
      serviceNumber: serviceNumber ?? this.serviceNumber,
      serviceModel: serviceModel ?? this.serviceModel,
    );
  }
}

class DeviceModel extends DeviceEntity {
  DeviceModel(
      {super.id,
      super.providerId,
      super.udid,
      super.token,
      super.snsArn,
      super.type});

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
        id: json['id'],
        providerId: json['provider_id'],
        udid: json['udid'],
        token: json['token'],
        snsArn: json['sns_arn'],
        type: json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['udid'] = udid;
    data['token'] = token;
    data['sns_arn'] = snsArn;
    data['type'] = type;
    return data;
  }

  DeviceModel copyWith({
    int? id,
    int? providerId,
    String? udid,
    String? token,
    dynamic? snsArn,
    String? type,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      udid: udid ?? this.udid,
      token: token ?? this.token,
      snsArn: snsArn ?? this.snsArn,
      type: type ?? this.type,
    );
  }
}
