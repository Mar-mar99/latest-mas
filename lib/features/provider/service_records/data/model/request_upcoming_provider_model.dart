import 'package:equatable/equatable.dart';

import '../../domain/entities/request_upcoming_provider_entity.dart';

class RequestUpcomingProviderModel extends RequestUpcomingProviderEntity {

  RequestUpcomingProviderModel(
      {
      super.id,
      super.bookingId,
      super.userId,
      super.providerId,
      super.currentProviderId,
      super.serviceTypeId,
      super.isEmergency,
      super.emergencyTime,
      super.emergencyPercentage,
      super.beforeImage,
      super.beforeComment,
      super.afterImage,
      super.afterComment,
      super.status,
      super.cancelledBy,
      super.cancelTime,
      super.cancelReason,
      super.paymentMode,
      super.paid,
      super.distance,
      super.sAddress,
      super.sLatitude,
      super.sLongitude,
      super.dAddress,
      super.dLatitude,
      super.dLongitude,
      super.assignedAt,
      super.scheduleAt,
      super.startedAt,
      super.finishedAt,
      super.userRated,
      super.providerRated,
      super.useWallet,
      super.reminder,
      super.pushCount,
      super.promocodeId,
      super.staticMap,
      super.totalServiceTimeInSeconds,
      super.totalServiceTime,
      super.emergencyTimeFormat,
      super.emergencyHourlyRate,
      super.emergencyTimePrice,
      super.images,
      super.serviceType,
      super.user,
      super.provider});

  factory RequestUpcomingProviderModel.fromJson(Map<String, dynamic> json) {
    var images = [];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images.add(v['image']);
      });
    } else {
      images = [];
    }
    return RequestUpcomingProviderModel(
        id: json['id'],
        bookingId: json['booking_id'],
        userId: json['user_id'],
        providerId: json['provider_id'],
        currentProviderId: json['current_provider_id'],
        serviceTypeId: json['service_type_id'],
        isEmergency: json['IsEmergency'],
        emergencyTime: json['emergency_time'],
        emergencyPercentage: json['emergency_percentage'],
        beforeImage: json['before_image'],
        beforeComment: json['before_comment'],
        afterImage: json['after_image'],
        afterComment: json['after_comment'],
        status: json['status'],
        cancelledBy: json['cancelled_by'],
        cancelTime: json['cancel_time'],
        cancelReason: json['cancel_reason'],
        paymentMode: json['payment_mode'],
        paid: json['paid'],
        distance: json['distance'],
        sAddress: json['s_address'],
        sLatitude: json['s_latitude'],
        sLongitude: json['s_longitude'],
        dAddress: json['d_address'],
        dLatitude: json['d_latitude'],
        dLongitude: json['d_longitude'],
        assignedAt: json['assigned_at'],
        scheduleAt: json['schedule_at'],
        startedAt: json['started_at'],
        finishedAt: json['finished_at'],
        userRated: json['user_rated'],
        providerRated: json['provider_rated'],
        useWallet: json['use_wallet'],
        reminder: json['reminder'],
        pushCount: json['push_count'],
        promocodeId: json['promocode_id'].toString(),
        staticMap: json['static_map'],
        totalServiceTimeInSeconds: json['total_service_time_in_seconds'],
        totalServiceTime: json['total_service_time'],
        emergencyTimeFormat: json['emergency_time_format'],
        emergencyHourlyRate: json['emergency_hourly_rate'],
        emergencyTimePrice: json['emergency_time_price'],
        images: images,
        serviceType: json['service_type'] != null
            ? ServiceTypeModel.fromJson(json['service_type'])
            : null,
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
        provider: json['provider'] != null
            ? ExpertModel.fromJson(json['provider'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['user_id'] = userId;
    data['provider_id'] = providerId;
    data['current_provider_id'] = currentProviderId;
    data['service_type_id'] = serviceTypeId;
    data['IsEmergency'] = isEmergency;
    data['emergency_time'] = emergencyTime;
    data['emergency_percentage'] = emergencyPercentage;
    data['before_image'] = beforeImage;
    data['before_comment'] = beforeComment;
    data['after_image'] = afterImage;
    data['after_comment'] = afterComment;
    data['status'] = status;
    data['cancelled_by'] = cancelledBy;
    data['cancel_time'] = cancelTime;
    data['cancel_reason'] = cancelReason;
    data['payment_mode'] = paymentMode;
    data['paid'] = paid;
    data['distance'] = distance;
    data['s_address'] = sAddress;
    data['s_latitude'] = sLatitude;
    data['s_longitude'] = sLongitude;
    data['d_address'] = dAddress;
    data['d_latitude'] = dLatitude;
    data['d_longitude'] = dLongitude;
    data['assigned_at'] = assignedAt;
    data['schedule_at'] = scheduleAt;
    data['started_at'] = startedAt;
    data['finished_at'] = finishedAt;
    data['user_rated'] = userRated;
    data['provider_rated'] = providerRated;
    data['use_wallet'] = useWallet;
    data['reminder'] = reminder;
    data['push_count'] = pushCount;
    data['promocode_id'] = promocodeId;
    data['static_map'] = staticMap;
    data['total_service_time_in_seconds'] = totalServiceTimeInSeconds;
    data['total_service_time'] = totalServiceTime;
    data['emergency_time_format'] = emergencyTimeFormat;
    data['emergency_hourly_rate'] = emergencyHourlyRate;
    data['emergency_time_price'] = emergencyTimePrice;
    data['images'] = images;

    if (serviceType != null) {
      data['service_type'] = (serviceType!as ServiceTypeModel) .toJson();
    }
    if (user != null) {
      data['user'] = (user! as UserModel) . toJson();
    }
    if (provider != null) {
      data['provider'] = (provider! as ExpertModel) .toJson();
    }
    return data;
  }


}

class ServiceTypeModel extends ServiceTypeEntity {

  ServiceTypeModel(
      {
      super.id,
      super.name,
      super.providerName,
      super.image,
      super.fixed,
      super.price,
      super.description,
      super.status,
      super.nameAr,
      super.nameUr,
      super.descriptionAr,
      super.descriptionUr,
      super.providerNameAr,
      super.providerNameUr,
      super.textColor,
      super.paymentStatus});

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      id: json['id'],
      name: json['name'],
      providerName: json['provider_name'],
      image: json['image'],
      fixed: json['fixed'],
      price: json['price'],
      description: json['description'],
      status: json['status'],
      nameAr: json['name_ar'],
      nameUr: json['name_ur'],
      descriptionAr: json['description_ar'],
      descriptionUr: json['description_ur'],
      providerNameAr: json['provider_name_ar'],
      providerNameUr: json['provider_name_ur'],
      textColor: json['text_color'],
      paymentStatus: json['payment_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['provider_name'] = providerName;
    data['image'] = image;
    data['fixed'] = fixed;
    data['price'] = price;
    data['description'] = description;
    data['status'] = status;
    data['name_ar'] = nameAr;
    data['name_ur'] = nameUr;
    data['description_ar'] = descriptionAr;
    data['description_ur'] = descriptionUr;
    data['provider_name_ar'] = providerNameAr;
    data['provider_name_ur'] = providerNameUr;
    data['text_color'] = textColor;
    data['payment_status'] = paymentStatus;
    return data;
  }


}

class UserModel extends UserEntity {

  UserModel(
      {
      super.id,
      super.firstName,
      super.lastName,
      super.paymentMode,
      super.email,
      super.picture,
      super.deviceToken,
      super.deviceId,
      super.deviceType,
      super.loginBy,
      super.socialUniqueId,
      super.mobile,
      super.latitude,
      super.longitude,
      super.stripeCustId,
      super.walletBalance,
      super.rating,
      super.ratingCount,
      super.otp,
      super.verified});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      paymentMode: json['payment_mode'],
      email: json['email'],
      picture: json['picture'],
      deviceToken: json['device_token'],
      deviceId: json['device_id'],
      deviceType: json['device_type'],
      loginBy: json['login_by'],
      socialUniqueId: json['social_unique_id'],
      mobile: json['mobile'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      stripeCustId: json['stripe_cust_id'],
      walletBalance: json['wallet_balance'],
      rating: json['rating'],
      ratingCount: json['rating_count'],
      otp: json['otp'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['payment_mode'] = paymentMode;
    data['email'] = email;
    data['picture'] = picture;
    data['device_token'] = deviceToken;
    data['device_id'] = deviceId;
    data['device_type'] = deviceType;
    data['login_by'] = loginBy;
    data['social_unique_id'] = socialUniqueId;
    data['mobile'] = mobile;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['stripe_cust_id'] = stripeCustId;
    data['wallet_balance'] = walletBalance;
    data['rating'] = rating;
    data['rating_count'] = ratingCount;
    data['otp'] = otp;
    data['verified'] = verified;
    return data;
  }


}

class ExpertModel extends ExpertEntity {

  ExpertModel(
      {
      super.id,
      super.companyId,
      super.firstName,
      super.lastName,
      super.name,
      super.email,
      super.phoneCode,
      super.mobile,
      super.avatar,
      super.description,
      super.rating,
      super.status,
      super.latitude,
      super.longitude,
      super.ratingCount,
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
      super.expertActive,
      super.expertOnline});

  factory ExpertModel.fromJson(Map<String, dynamic> json) {
    return ExpertModel(
      id: json['id'],
      companyId: json['company_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      name: json['name'],
      email: json['email'],
      phoneCode: json['phone_code'],
      mobile: json['mobile'],
      avatar: json['avatar'],
      description: json['description'],
      rating: json['rating'],
      status: json['status'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      ratingCount: json['rating_count'],
      otp: json['otp'],
      verified: json['verified'],
      stripeAccId: json['stripe_acc_id'],
      isStripeinfoFilled: json['is_stripeinfo_filled'],
      isStripeConnected: json['is_stripe_connected'],
      type: json['type'],
      providersCount: json['providers_count'],
      commission: json['commission'],
      local: json['local'],
      address: json['address'],
      expertActive: json['expertActive'],
      expertOnline: json['expertOnline'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['email'] = email;
    data['phone_code'] = phoneCode;
    data['mobile'] = mobile;
    data['avatar'] = avatar;
    data['description'] = description;
    data['rating'] = rating;
    data['status'] = status;
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
    data['expertOnline'] = expertOnline;
    return data;
  }


}
